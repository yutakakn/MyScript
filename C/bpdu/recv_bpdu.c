/*
 * BPDU を受信する
 *
 * for Compile(gcc 8.1)
 * # cc -Wall recv_bpdu.c -o recv_bpdu
 *
 * Mandatory: Administrator privilege
 * # sudo ./recv_bpdu
 *
 * Created by Yutaka Hirata(@yutakakn)
 * Initial: 2018/9/14
 */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <arpa/inet.h>
#include <linux/if_ether.h>
#include <linux/filter.h>
#include <linux/kernel.h>
#include <netpacket/packet.h>
#include <net/if.h>

#define DEFAULT_DEVICE "lo"

/* BPDUのパケットフィルタ */
struct sock_filter bpdu_filter[] = {
    BPF_STMT(BPF_LD | BPF_W | BPF_ABS, 0),  // A<-P[0:4]
    BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, 0x0180C200, 0, 1), // A==k?0:1
    BPF_STMT(BPF_LD | BPF_H | BPF_ABS, 12),  // A<-P[12:2]
    BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, 0x0026, 0, 1), // A==k?0:1
    BPF_STMT(BPF_RET | BPF_K, -1), // ret #-1(hit!)
    BPF_STMT(BPF_RET | BPF_K, 0) // ret #0(packet ignored)
};

struct sock_fprog bpdu_bpf = {
    .len = sizeof(bpdu_filter)/sizeof(bpdu_filter[0]),
    .filter = bpdu_filter,
};

/* 送信するインターフェイス名 
 * -d オプションで変更可能。 
 */
char g_network_interface[IFNAMSIZ] = DEFAULT_DEVICE;

void show_help(char *prog)
{
	printf("Usage: %s \n"
		   "[-d <device>] (default - %s)\n"
		   "[-h]\n"
		   "\n"
		   "Mandatory: root privilege\n",
		   prog,
		   DEFAULT_DEVICE
		  );
}

void parse_option(int argc, char **argv)
{
	int opt;
	int len;

	if (getuid() != 0) {
		show_help(argv[0]);
		exit(1);
	}

	while ( (opt = getopt(argc, argv, "d:h")) != -1 ) {
		switch (opt) {
			case 'd':
				len = sizeof(g_network_interface);
				memset(g_network_interface, 0, len);
				strncpy(g_network_interface, optarg, len - 1);
				break;

			case 'h':
			default:
				show_help(argv[0]);
				exit(0);
				break;
		}
	}

	if (optind < argc) {
		printf("Non expected argument after options\n");
		exit(1);
	}
}


void snoop_packet(void)
{
    int sock = -1;
    struct ifreq ifr;
    struct sockaddr_ll sll;
    unsigned char buf[4096];
	int ret;
	int len;
	int i;

	/* RAW socketの作成(root権限必要) */
    sock = socket(AF_PACKET, SOCK_RAW, htons(ETH_P_ALL));
	if (sock == -1) {
		perror("socket");
		goto error;
	}

	/* 受信するインターフェイスのインデックスを取得する */
    memset(&ifr, 0, sizeof(ifr));
	len = IFNAMSIZ;
    strncpy(ifr.ifr_name, g_network_interface, len - 1);
    ret = ioctl(sock, SIOCGIFINDEX, &ifr);
	if (ret < 0) {
		perror("ioctl");
		goto error;
	}

	/* 受信インターフェイスをbindする */
    memset(&sll, 0, sizeof(sll));
    sll.sll_family = AF_PACKET;
    sll.sll_protocol = htons(ETH_P_ALL);
    sll.sll_ifindex = ifr.ifr_ifindex;
    ret = bind(sock, (struct sockaddr *)&sll, sizeof(sll));
	if (ret < 0) {
		perror("bind");
		goto error;
	}

	/* パケットフィルタの設定 */
    ret = setsockopt(sock, SOL_SOCKET, SO_ATTACH_FILTER, 
			&bpdu_bpf, sizeof(bpdu_bpf));
	if (ret < 0) {
		perror("setsockopt");
		exit(1);
	}

	/* パケットの受信待ち */
	for ( ;; ) {
        len = recv(sock, buf, sizeof(buf), 0);
        if (len <= 0) 
			break;

		printf("%d bytes received.\n", len);
		for (i = 0 ; i < len ; i++) {
			if (i % 16 == 0)
				printf("\n");
			printf("%02x ", buf[i]);
		}
		printf("\n\n");
    }

error:
	if (sock != -1)
		close(sock);
}

int main(int argc, char **argv)
{
	parse_option(argc, argv);

	snoop_packet();

	return 0;
}

