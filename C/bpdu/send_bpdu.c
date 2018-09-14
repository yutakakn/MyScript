/*
 * BPDU を送信する
 *
 * for Compile(gcc 8.1)
 * # cc -Wall send_bpdu.c -o send_bpdu
 *
 * Mandatory: Administrator privilege
 * # sudo ./send_bpdu
 *
 * Created by Yutaka Hirata(@yutakakn)
 * Initial: 2018/9/14
 */
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <ctype.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <net/if.h>
#include <netinet/if_ether.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <netpacket/packet.h>

#define DEFAULT_DEVICE "lo"
#define DEFAULT_SMAC "6C:4B:90:11:22:33"
#define DEFAULT_DMAC "01:80:C2:00:00:00" /* default multicast mac for stp*/
#define DEFAULT_PROTO_ID "0000"
#define DEFAULT_PROTO_V_ID "00"
#define DEFAULT_BPDU_TYPE "00"
#define DEFAULT_FLAGS "00"
#define DEFAULT_ROOT_ID "800000000c00018e" /*mac address:00000C(cisco)00018E*/
#define DEFAULT_ROOT_PC "00000000"
#define DEFAULT_BR_ID "800000000c00018e"
#define DEFAULT_PORT_ID "8002"
#define DEFAULT_MESSAGE_AGE "0000"
#define DEFAULT_MAX_AGE "1400"
#define DEFAULT_HELLO_TIME "0200"
#define DEFAULT_FORWARD_DELAY "1E00"

#pragma pack(1)
struct bpdu_packet {
	unsigned char dmac[6]; /* dest. ether address */
	unsigned char smac[6]; /* src. ether address */
	unsigned char frame_type[2]; /* 0x00 0x26 */
	unsigned char llc_dsap; /* 0x42 */
	unsigned char llc_ssap; /* 0x42 */
	unsigned char command; /* 03 command */
	unsigned char protoid[2]; /* Protocol Identifier */
	unsigned char protovid[1]; /* Protocol Version Identifier */
	unsigned char bpdu[1]; /* BPDU Type */
	unsigned char flags[1]; /* Flags */
	unsigned char rootid[8]; /* Root Identifier */
	unsigned char rootpc[4]; /* Root Path Cost */
	unsigned char brid[8]; /* Bridge Identifier */
	unsigned char portid[2]; /* Port Identifier */
	unsigned char mage[2]; /* Message Age */
	unsigned char maxage[2]; /* Max Age */
	unsigned char hellotime[2]; /* Hello Time */
	unsigned char fdelay[2]; /* Forward Delay */
};
#pragma pack()

/* 送信元MACアドレス
 * -m オプションで変更可能。 
 */
char g_def_src_mac[] = DEFAULT_SMAC;

/* 送信するインターフェイス名 
 * -d オプションで変更可能。 
 */
char g_network_interface[IFNAMSIZ] = DEFAULT_DEVICE;

int get_string_value(char str)
{
	int c;
	int val;

	if (!(c = tolower(str))) {
		printf("Invalid hex value conversion MSB\n");
		exit(1);
	}
	
	if (isdigit(c)) {
		val = c - '0';
	} else if (c >= 'a' && c <= 'f') {
		val = c - 'a' + 10;
	} else {
		printf("Invalid hex value out of reach MSB\n");
		exit(1);
	}

	return (val);
}

void change_field(unsigned char *buf, char *str, int len)
{
	unsigned char *buf_org = buf;
	int i;
	int val;

	for (i = 0; i < len; i++) {
		val = get_string_value(*str++);
		*buf = val << 4;

		val = get_string_value(*str++);
		*buf++ |= val;

		if (*str == ':')
			str++;
	}

	buf_org = buf_org;
#if 0
	for (i = 0; i < len; i++) {
		printf("%02x ", buf_org[i]);
	}
	printf("\n");
#endif
}

/* 
 * BPDUパケット(IEEE802.3+LLC)を構築する 
 */
void build_stp_packet(struct bpdu_packet *stp)
{
	int len = sizeof(struct bpdu_packet);

	printf("BPDU Ethernet frame size %d bytes\n", len);
	
	memset(stp, 0, len);
	
	/* EthernetヘッダとLLC */
	change_field(stp->dmac, DEFAULT_DMAC, 6);
	change_field(stp->smac, g_def_src_mac, 6);

	/* Frame typeはLLCとBPDUのサイズを示す。
	 * つまり、LLC(3)+BPDU(35)で38(0x26)。
	 */
	stp->frame_type[0] = 0x00;
	stp->frame_type[1] = 0x26;
	stp->llc_dsap = 0x42;
	stp->llc_ssap = 0x42;
	stp->command = 0x03;
	
	/* BPDU */
	change_field(stp->protoid, DEFAULT_PROTO_ID, 2);
	change_field(stp->protovid, DEFAULT_PROTO_V_ID, 1);
	change_field(stp->bpdu, DEFAULT_BPDU_TYPE, 1);
	change_field(stp->flags, DEFAULT_FLAGS, 1);
	change_field(stp->rootid, DEFAULT_ROOT_ID, 8);
	change_field(stp->rootpc, DEFAULT_ROOT_PC, 4);
	change_field(stp->brid, DEFAULT_BR_ID, 8);
	change_field(stp->portid, DEFAULT_PORT_ID, 2);
	change_field(stp->mage, DEFAULT_MESSAGE_AGE, 2);
	change_field(stp->maxage, DEFAULT_MAX_AGE, 2);
	change_field(stp->hellotime, DEFAULT_HELLO_TIME, 2);
	change_field(stp->fdelay, DEFAULT_FORWARD_DELAY, 2);
}

void send_packet(struct bpdu_packet *stp, int pktlen)
{
	int sock = -1;
	int ret, len;
    struct sockaddr_ll sll;
    struct ifreq ifr;

	/* RAW socketの作成(root権限必要) */
    sock = socket(AF_PACKET, SOCK_RAW, htons(ETH_P_ALL));
	if (sock < 0) {
		perror("Can't create socket\n");
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

    memset(&sll, 0, sizeof(sll));
    sll.sll_family = AF_PACKET;
    sll.sll_protocol = htons(ETH_P_ALL);
    sll.sll_ifindex = ifr.ifr_ifindex;

	/* パケット送信 */
	len = pktlen;
	ret = sendto(sock, (char *)stp, len, 0, (struct sockaddr *)&sll, sizeof(sll));
	if (ret == -1 || (ret < len)) {
		perror("sendto error\n");
		goto error;
	}

	printf("Send success!(%d bytes was sent)\n" 
		   "Device=%s Source MAC=%s\n",
			ret, 
			g_network_interface, g_def_src_mac);

error:;
	// ソケットのクローズ
	if (sock != -1)
		close(sock);
}

void show_help(char *prog)
{
	printf("Usage: %s \n"
		   "[-d <device>] (default - %s)\n"
		   "[-m <source MAC>] (default - %s)\n"
		   "[-h]\n"
		   "\n"
		   "Mandatory: root privilege\n",
		   prog,
		   DEFAULT_DEVICE,
		   DEFAULT_SMAC
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

	while ( (opt = getopt(argc, argv, "d:m:h")) != -1 ) {
		switch (opt) {
			case 'd':
				len = sizeof(g_network_interface);
				memset(g_network_interface, 0, len);
				strncpy(g_network_interface, optarg, len - 1);
				break;

			case 'm':
				len = sizeof(g_def_src_mac);
				memset(g_def_src_mac, 0, len);
				strncpy(g_def_src_mac, optarg, len - 1);
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

int main(int argc, char **argv)
{
	struct bpdu_packet stp;

	/* オプション解析 */
	parse_option(argc, argv);
	
	/* パケットの構築 */
	build_stp_packet(&stp);

	/* パケットの送信 */
	send_packet(&stp, sizeof(stp));

	return 0;
}

