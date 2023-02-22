
user/_sysinfotest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <sinfo>:
#include "kernel/sysinfo.h"
#include "user/user.h"


void
sinfo(struct sysinfo *info) {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if (sysinfo(info) < 0) {
   8:	00000097          	auipc	ra,0x0
   c:	6ee080e7          	jalr	1774(ra) # 6f6 <sysinfo>
  10:	00054663          	bltz	a0,1c <sinfo+0x1c>
    printf("FAIL: sysinfo failed");
    exit(1);
  }
}
  14:	60a2                	ld	ra,8(sp)
  16:	6402                	ld	s0,0(sp)
  18:	0141                	addi	sp,sp,16
  1a:	8082                	ret
    printf("FAIL: sysinfo failed");
  1c:	00001517          	auipc	a0,0x1
  20:	b7450513          	addi	a0,a0,-1164 # b90 <malloc+0xfc>
  24:	00001097          	auipc	ra,0x1
  28:	9b2080e7          	jalr	-1614(ra) # 9d6 <printf>
    exit(1);
  2c:	4505                	li	a0,1
  2e:	00000097          	auipc	ra,0x0
  32:	620080e7          	jalr	1568(ra) # 64e <exit>

0000000000000036 <countfree>:
//
// use sbrk() to count how many free physical memory pages there are.
//
int
countfree()
{
  36:	7139                	addi	sp,sp,-64
  38:	fc06                	sd	ra,56(sp)
  3a:	f822                	sd	s0,48(sp)
  3c:	f426                	sd	s1,40(sp)
  3e:	f04a                	sd	s2,32(sp)
  40:	ec4e                	sd	s3,24(sp)
  42:	e852                	sd	s4,16(sp)
  44:	0080                	addi	s0,sp,64
  uint64 sz0 = (uint64)sbrk(0);
  46:	4501                	li	a0,0
  48:	00000097          	auipc	ra,0x0
  4c:	68e080e7          	jalr	1678(ra) # 6d6 <sbrk>
  50:	8a2a                	mv	s4,a0
  struct sysinfo info;
  int n = 0;
  52:	4481                	li	s1,0

  while(1){
    if((uint64)sbrk(PGSIZE) == 0xffffffffffffffff){
  54:	597d                	li	s2,-1
      break;
    }
    n += PGSIZE;
  56:	6985                	lui	s3,0x1
    if((uint64)sbrk(PGSIZE) == 0xffffffffffffffff){
  58:	6505                	lui	a0,0x1
  5a:	00000097          	auipc	ra,0x0
  5e:	67c080e7          	jalr	1660(ra) # 6d6 <sbrk>
  62:	01250563          	beq	a0,s2,6c <countfree+0x36>
    n += PGSIZE;
  66:	009984bb          	addw	s1,s3,s1
    if((uint64)sbrk(PGSIZE) == 0xffffffffffffffff){
  6a:	b7fd                	j	58 <countfree+0x22>
  }
  sinfo(&info);
  6c:	fc040513          	addi	a0,s0,-64
  70:	00000097          	auipc	ra,0x0
  74:	f90080e7          	jalr	-112(ra) # 0 <sinfo>
  if (info.freemem != 0) {
  78:	fc043583          	ld	a1,-64(s0)
  7c:	e58d                	bnez	a1,a6 <countfree+0x70>
    printf("FAIL: there is no free mem, but sysinfo.freemem=%d\n",
      info.freemem);
    exit(1);
  }
  sbrk(-((uint64)sbrk(0) - sz0));
  7e:	4501                	li	a0,0
  80:	00000097          	auipc	ra,0x0
  84:	656080e7          	jalr	1622(ra) # 6d6 <sbrk>
  88:	40aa053b          	subw	a0,s4,a0
  8c:	00000097          	auipc	ra,0x0
  90:	64a080e7          	jalr	1610(ra) # 6d6 <sbrk>
  return n;
}
  94:	8526                	mv	a0,s1
  96:	70e2                	ld	ra,56(sp)
  98:	7442                	ld	s0,48(sp)
  9a:	74a2                	ld	s1,40(sp)
  9c:	7902                	ld	s2,32(sp)
  9e:	69e2                	ld	s3,24(sp)
  a0:	6a42                	ld	s4,16(sp)
  a2:	6121                	addi	sp,sp,64
  a4:	8082                	ret
    printf("FAIL: there is no free mem, but sysinfo.freemem=%d\n",
  a6:	00001517          	auipc	a0,0x1
  aa:	b0250513          	addi	a0,a0,-1278 # ba8 <malloc+0x114>
  ae:	00001097          	auipc	ra,0x1
  b2:	928080e7          	jalr	-1752(ra) # 9d6 <printf>
    exit(1);
  b6:	4505                	li	a0,1
  b8:	00000097          	auipc	ra,0x0
  bc:	596080e7          	jalr	1430(ra) # 64e <exit>

00000000000000c0 <testmem>:

void
testmem() {
  c0:	7179                	addi	sp,sp,-48
  c2:	f406                	sd	ra,40(sp)
  c4:	f022                	sd	s0,32(sp)
  c6:	ec26                	sd	s1,24(sp)
  c8:	e84a                	sd	s2,16(sp)
  ca:	1800                	addi	s0,sp,48
  struct sysinfo info;
  uint64 n = countfree();
  cc:	00000097          	auipc	ra,0x0
  d0:	f6a080e7          	jalr	-150(ra) # 36 <countfree>
  d4:	84aa                	mv	s1,a0
  
  sinfo(&info);
  d6:	fd040513          	addi	a0,s0,-48
  da:	00000097          	auipc	ra,0x0
  de:	f26080e7          	jalr	-218(ra) # 0 <sinfo>

  if (info.freemem!= n) {
  e2:	fd043583          	ld	a1,-48(s0)
  e6:	04959e63          	bne	a1,s1,142 <testmem+0x82>
    printf("FAIL: free mem %d (bytes) instead of %d\n", info.freemem, n);
    exit(1);
  }
  
  if((uint64)sbrk(PGSIZE) == 0xffffffffffffffff){
  ea:	6505                	lui	a0,0x1
  ec:	00000097          	auipc	ra,0x0
  f0:	5ea080e7          	jalr	1514(ra) # 6d6 <sbrk>
  f4:	57fd                	li	a5,-1
  f6:	06f50463          	beq	a0,a5,15e <testmem+0x9e>
    printf("sbrk failed");
    exit(1);
  }

  sinfo(&info);
  fa:	fd040513          	addi	a0,s0,-48
  fe:	00000097          	auipc	ra,0x0
 102:	f02080e7          	jalr	-254(ra) # 0 <sinfo>
    
  if (info.freemem != n-PGSIZE) {
 106:	fd043603          	ld	a2,-48(s0)
 10a:	75fd                	lui	a1,0xfffff
 10c:	95a6                	add	a1,a1,s1
 10e:	06b61563          	bne	a2,a1,178 <testmem+0xb8>
    printf("FAIL: free mem %d (bytes) instead of %d\n", n-PGSIZE, info.freemem);
    exit(1);
  }
  
  if((uint64)sbrk(-PGSIZE) == 0xffffffffffffffff){
 112:	757d                	lui	a0,0xfffff
 114:	00000097          	auipc	ra,0x0
 118:	5c2080e7          	jalr	1474(ra) # 6d6 <sbrk>
 11c:	57fd                	li	a5,-1
 11e:	06f50a63          	beq	a0,a5,192 <testmem+0xd2>
    printf("sbrk failed");
    exit(1);
  }

  sinfo(&info);
 122:	fd040513          	addi	a0,s0,-48
 126:	00000097          	auipc	ra,0x0
 12a:	eda080e7          	jalr	-294(ra) # 0 <sinfo>
    
  if (info.freemem != n) {
 12e:	fd043603          	ld	a2,-48(s0)
 132:	06961d63          	bne	a2,s1,1ac <testmem+0xec>
    printf("FAIL: free mem %d (bytes) instead of %d\n", n, info.freemem);
    exit(1);
  }
}
 136:	70a2                	ld	ra,40(sp)
 138:	7402                	ld	s0,32(sp)
 13a:	64e2                	ld	s1,24(sp)
 13c:	6942                	ld	s2,16(sp)
 13e:	6145                	addi	sp,sp,48
 140:	8082                	ret
    printf("FAIL: free mem %d (bytes) instead of %d\n", info.freemem, n);
 142:	8626                	mv	a2,s1
 144:	00001517          	auipc	a0,0x1
 148:	a9c50513          	addi	a0,a0,-1380 # be0 <malloc+0x14c>
 14c:	00001097          	auipc	ra,0x1
 150:	88a080e7          	jalr	-1910(ra) # 9d6 <printf>
    exit(1);
 154:	4505                	li	a0,1
 156:	00000097          	auipc	ra,0x0
 15a:	4f8080e7          	jalr	1272(ra) # 64e <exit>
    printf("sbrk failed");
 15e:	00001517          	auipc	a0,0x1
 162:	ab250513          	addi	a0,a0,-1358 # c10 <malloc+0x17c>
 166:	00001097          	auipc	ra,0x1
 16a:	870080e7          	jalr	-1936(ra) # 9d6 <printf>
    exit(1);
 16e:	4505                	li	a0,1
 170:	00000097          	auipc	ra,0x0
 174:	4de080e7          	jalr	1246(ra) # 64e <exit>
    printf("FAIL: free mem %d (bytes) instead of %d\n", n-PGSIZE, info.freemem);
 178:	00001517          	auipc	a0,0x1
 17c:	a6850513          	addi	a0,a0,-1432 # be0 <malloc+0x14c>
 180:	00001097          	auipc	ra,0x1
 184:	856080e7          	jalr	-1962(ra) # 9d6 <printf>
    exit(1);
 188:	4505                	li	a0,1
 18a:	00000097          	auipc	ra,0x0
 18e:	4c4080e7          	jalr	1220(ra) # 64e <exit>
    printf("sbrk failed");
 192:	00001517          	auipc	a0,0x1
 196:	a7e50513          	addi	a0,a0,-1410 # c10 <malloc+0x17c>
 19a:	00001097          	auipc	ra,0x1
 19e:	83c080e7          	jalr	-1988(ra) # 9d6 <printf>
    exit(1);
 1a2:	4505                	li	a0,1
 1a4:	00000097          	auipc	ra,0x0
 1a8:	4aa080e7          	jalr	1194(ra) # 64e <exit>
    printf("FAIL: free mem %d (bytes) instead of %d\n", n, info.freemem);
 1ac:	85a6                	mv	a1,s1
 1ae:	00001517          	auipc	a0,0x1
 1b2:	a3250513          	addi	a0,a0,-1486 # be0 <malloc+0x14c>
 1b6:	00001097          	auipc	ra,0x1
 1ba:	820080e7          	jalr	-2016(ra) # 9d6 <printf>
    exit(1);
 1be:	4505                	li	a0,1
 1c0:	00000097          	auipc	ra,0x0
 1c4:	48e080e7          	jalr	1166(ra) # 64e <exit>

00000000000001c8 <testcall>:

void
testcall() {
 1c8:	1101                	addi	sp,sp,-32
 1ca:	ec06                	sd	ra,24(sp)
 1cc:	e822                	sd	s0,16(sp)
 1ce:	1000                	addi	s0,sp,32
  struct sysinfo info;
  
  if (sysinfo(&info) < 0) {
 1d0:	fe040513          	addi	a0,s0,-32
 1d4:	00000097          	auipc	ra,0x0
 1d8:	522080e7          	jalr	1314(ra) # 6f6 <sysinfo>
 1dc:	02054163          	bltz	a0,1fe <testcall+0x36>
    printf("FAIL: sysinfo failed\n");
    exit(1);
  }

  if (sysinfo((struct sysinfo *) 0xeaeb0b5b00002f5e) !=  0xffffffffffffffff) {
 1e0:	00001517          	auipc	a0,0x1
 1e4:	9a053503          	ld	a0,-1632(a0) # b80 <malloc+0xec>
 1e8:	00000097          	auipc	ra,0x0
 1ec:	50e080e7          	jalr	1294(ra) # 6f6 <sysinfo>
 1f0:	57fd                	li	a5,-1
 1f2:	02f51363          	bne	a0,a5,218 <testcall+0x50>
    printf("FAIL: sysinfo succeeded with bad argument\n");
    exit(1);
  }
}
 1f6:	60e2                	ld	ra,24(sp)
 1f8:	6442                	ld	s0,16(sp)
 1fa:	6105                	addi	sp,sp,32
 1fc:	8082                	ret
    printf("FAIL: sysinfo failed\n");
 1fe:	00001517          	auipc	a0,0x1
 202:	a2250513          	addi	a0,a0,-1502 # c20 <malloc+0x18c>
 206:	00000097          	auipc	ra,0x0
 20a:	7d0080e7          	jalr	2000(ra) # 9d6 <printf>
    exit(1);
 20e:	4505                	li	a0,1
 210:	00000097          	auipc	ra,0x0
 214:	43e080e7          	jalr	1086(ra) # 64e <exit>
    printf("FAIL: sysinfo succeeded with bad argument\n");
 218:	00001517          	auipc	a0,0x1
 21c:	a2050513          	addi	a0,a0,-1504 # c38 <malloc+0x1a4>
 220:	00000097          	auipc	ra,0x0
 224:	7b6080e7          	jalr	1974(ra) # 9d6 <printf>
    exit(1);
 228:	4505                	li	a0,1
 22a:	00000097          	auipc	ra,0x0
 22e:	424080e7          	jalr	1060(ra) # 64e <exit>

0000000000000232 <testproc>:

void testproc() {
 232:	7139                	addi	sp,sp,-64
 234:	fc06                	sd	ra,56(sp)
 236:	f822                	sd	s0,48(sp)
 238:	f426                	sd	s1,40(sp)
 23a:	0080                	addi	s0,sp,64
  struct sysinfo info;
  uint64 nproc;
  int status;
  int pid;
  
  sinfo(&info);
 23c:	fd040513          	addi	a0,s0,-48
 240:	00000097          	auipc	ra,0x0
 244:	dc0080e7          	jalr	-576(ra) # 0 <sinfo>
  nproc = info.nproc;
 248:	fd843483          	ld	s1,-40(s0)

  pid = fork();
 24c:	00000097          	auipc	ra,0x0
 250:	3fa080e7          	jalr	1018(ra) # 646 <fork>
  if(pid < 0){
 254:	02054c63          	bltz	a0,28c <testproc+0x5a>
    printf("sysinfotest: fork failed\n");
    exit(1);
  }
  if(pid == 0){
 258:	ed21                	bnez	a0,2b0 <testproc+0x7e>
    sinfo(&info);
 25a:	fd040513          	addi	a0,s0,-48
 25e:	00000097          	auipc	ra,0x0
 262:	da2080e7          	jalr	-606(ra) # 0 <sinfo>
    if(info.nproc != nproc+1) {
 266:	fd843583          	ld	a1,-40(s0)
 26a:	00148613          	addi	a2,s1,1
 26e:	02c58c63          	beq	a1,a2,2a6 <testproc+0x74>
      printf("sysinfotest: FAIL nproc is %d instead of %d\n", info.nproc, nproc+1);
 272:	00001517          	auipc	a0,0x1
 276:	a1650513          	addi	a0,a0,-1514 # c88 <malloc+0x1f4>
 27a:	00000097          	auipc	ra,0x0
 27e:	75c080e7          	jalr	1884(ra) # 9d6 <printf>
      exit(1);
 282:	4505                	li	a0,1
 284:	00000097          	auipc	ra,0x0
 288:	3ca080e7          	jalr	970(ra) # 64e <exit>
    printf("sysinfotest: fork failed\n");
 28c:	00001517          	auipc	a0,0x1
 290:	9dc50513          	addi	a0,a0,-1572 # c68 <malloc+0x1d4>
 294:	00000097          	auipc	ra,0x0
 298:	742080e7          	jalr	1858(ra) # 9d6 <printf>
    exit(1);
 29c:	4505                	li	a0,1
 29e:	00000097          	auipc	ra,0x0
 2a2:	3b0080e7          	jalr	944(ra) # 64e <exit>
    }
    exit(0);
 2a6:	4501                	li	a0,0
 2a8:	00000097          	auipc	ra,0x0
 2ac:	3a6080e7          	jalr	934(ra) # 64e <exit>
  }
  wait(&status);
 2b0:	fcc40513          	addi	a0,s0,-52
 2b4:	00000097          	auipc	ra,0x0
 2b8:	3a2080e7          	jalr	930(ra) # 656 <wait>
  sinfo(&info);
 2bc:	fd040513          	addi	a0,s0,-48
 2c0:	00000097          	auipc	ra,0x0
 2c4:	d40080e7          	jalr	-704(ra) # 0 <sinfo>
  if(info.nproc != nproc) {
 2c8:	fd843583          	ld	a1,-40(s0)
 2cc:	00959763          	bne	a1,s1,2da <testproc+0xa8>
      printf("sysinfotest: FAIL nproc is %d instead of %d\n", info.nproc, nproc);
      exit(1);
  }
}
 2d0:	70e2                	ld	ra,56(sp)
 2d2:	7442                	ld	s0,48(sp)
 2d4:	74a2                	ld	s1,40(sp)
 2d6:	6121                	addi	sp,sp,64
 2d8:	8082                	ret
      printf("sysinfotest: FAIL nproc is %d instead of %d\n", info.nproc, nproc);
 2da:	8626                	mv	a2,s1
 2dc:	00001517          	auipc	a0,0x1
 2e0:	9ac50513          	addi	a0,a0,-1620 # c88 <malloc+0x1f4>
 2e4:	00000097          	auipc	ra,0x0
 2e8:	6f2080e7          	jalr	1778(ra) # 9d6 <printf>
      exit(1);
 2ec:	4505                	li	a0,1
 2ee:	00000097          	auipc	ra,0x0
 2f2:	360080e7          	jalr	864(ra) # 64e <exit>

00000000000002f6 <testbad>:

void testbad() {
 2f6:	1101                	addi	sp,sp,-32
 2f8:	ec06                	sd	ra,24(sp)
 2fa:	e822                	sd	s0,16(sp)
 2fc:	1000                	addi	s0,sp,32
  int pid = fork();
 2fe:	00000097          	auipc	ra,0x0
 302:	348080e7          	jalr	840(ra) # 646 <fork>
  int xstatus;
  
  if(pid < 0){
 306:	00054c63          	bltz	a0,31e <testbad+0x28>
    printf("sysinfotest: fork failed\n");
    exit(1);
  }
  if(pid == 0){
 30a:	e51d                	bnez	a0,338 <testbad+0x42>
      sinfo(0x0);
 30c:	00000097          	auipc	ra,0x0
 310:	cf4080e7          	jalr	-780(ra) # 0 <sinfo>
      exit(0);
 314:	4501                	li	a0,0
 316:	00000097          	auipc	ra,0x0
 31a:	338080e7          	jalr	824(ra) # 64e <exit>
    printf("sysinfotest: fork failed\n");
 31e:	00001517          	auipc	a0,0x1
 322:	94a50513          	addi	a0,a0,-1718 # c68 <malloc+0x1d4>
 326:	00000097          	auipc	ra,0x0
 32a:	6b0080e7          	jalr	1712(ra) # 9d6 <printf>
    exit(1);
 32e:	4505                	li	a0,1
 330:	00000097          	auipc	ra,0x0
 334:	31e080e7          	jalr	798(ra) # 64e <exit>
  }
  wait(&xstatus);
 338:	fec40513          	addi	a0,s0,-20
 33c:	00000097          	auipc	ra,0x0
 340:	31a080e7          	jalr	794(ra) # 656 <wait>
  if(xstatus == -1)  // kernel killed child?
 344:	fec42583          	lw	a1,-20(s0)
 348:	57fd                	li	a5,-1
 34a:	02f58063          	beq	a1,a5,36a <testbad+0x74>
    exit(0);
  else {
    printf("sysinfotest: testbad succeeded %d\n", xstatus);
 34e:	00001517          	auipc	a0,0x1
 352:	96a50513          	addi	a0,a0,-1686 # cb8 <malloc+0x224>
 356:	00000097          	auipc	ra,0x0
 35a:	680080e7          	jalr	1664(ra) # 9d6 <printf>
    exit(xstatus);
 35e:	fec42503          	lw	a0,-20(s0)
 362:	00000097          	auipc	ra,0x0
 366:	2ec080e7          	jalr	748(ra) # 64e <exit>
    exit(0);
 36a:	4501                	li	a0,0
 36c:	00000097          	auipc	ra,0x0
 370:	2e2080e7          	jalr	738(ra) # 64e <exit>

0000000000000374 <main>:
  }
}

int
main(int argc, char *argv[])
{
 374:	1141                	addi	sp,sp,-16
 376:	e406                	sd	ra,8(sp)
 378:	e022                	sd	s0,0(sp)
 37a:	0800                	addi	s0,sp,16
  printf("sysinfotest: start\n");
 37c:	00001517          	auipc	a0,0x1
 380:	96450513          	addi	a0,a0,-1692 # ce0 <malloc+0x24c>
 384:	00000097          	auipc	ra,0x0
 388:	652080e7          	jalr	1618(ra) # 9d6 <printf>
  testcall();
 38c:	00000097          	auipc	ra,0x0
 390:	e3c080e7          	jalr	-452(ra) # 1c8 <testcall>
  testmem();
 394:	00000097          	auipc	ra,0x0
 398:	d2c080e7          	jalr	-724(ra) # c0 <testmem>
  testproc();
 39c:	00000097          	auipc	ra,0x0
 3a0:	e96080e7          	jalr	-362(ra) # 232 <testproc>
  printf("sysinfotest: OK\n");
 3a4:	00001517          	auipc	a0,0x1
 3a8:	95450513          	addi	a0,a0,-1708 # cf8 <malloc+0x264>
 3ac:	00000097          	auipc	ra,0x0
 3b0:	62a080e7          	jalr	1578(ra) # 9d6 <printf>
  exit(0);
 3b4:	4501                	li	a0,0
 3b6:	00000097          	auipc	ra,0x0
 3ba:	298080e7          	jalr	664(ra) # 64e <exit>

00000000000003be <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 3be:	1141                	addi	sp,sp,-16
 3c0:	e406                	sd	ra,8(sp)
 3c2:	e022                	sd	s0,0(sp)
 3c4:	0800                	addi	s0,sp,16
  extern int main();
  main();
 3c6:	00000097          	auipc	ra,0x0
 3ca:	fae080e7          	jalr	-82(ra) # 374 <main>
  exit(0);
 3ce:	4501                	li	a0,0
 3d0:	00000097          	auipc	ra,0x0
 3d4:	27e080e7          	jalr	638(ra) # 64e <exit>

00000000000003d8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 3d8:	1141                	addi	sp,sp,-16
 3da:	e422                	sd	s0,8(sp)
 3dc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3de:	87aa                	mv	a5,a0
 3e0:	0585                	addi	a1,a1,1
 3e2:	0785                	addi	a5,a5,1
 3e4:	fff5c703          	lbu	a4,-1(a1) # ffffffffffffefff <base+0xffffffffffffdfef>
 3e8:	fee78fa3          	sb	a4,-1(a5)
 3ec:	fb75                	bnez	a4,3e0 <strcpy+0x8>
    ;
  return os;
}
 3ee:	6422                	ld	s0,8(sp)
 3f0:	0141                	addi	sp,sp,16
 3f2:	8082                	ret

00000000000003f4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3f4:	1141                	addi	sp,sp,-16
 3f6:	e422                	sd	s0,8(sp)
 3f8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 3fa:	00054783          	lbu	a5,0(a0)
 3fe:	cb91                	beqz	a5,412 <strcmp+0x1e>
 400:	0005c703          	lbu	a4,0(a1)
 404:	00f71763          	bne	a4,a5,412 <strcmp+0x1e>
    p++, q++;
 408:	0505                	addi	a0,a0,1
 40a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 40c:	00054783          	lbu	a5,0(a0)
 410:	fbe5                	bnez	a5,400 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 412:	0005c503          	lbu	a0,0(a1)
}
 416:	40a7853b          	subw	a0,a5,a0
 41a:	6422                	ld	s0,8(sp)
 41c:	0141                	addi	sp,sp,16
 41e:	8082                	ret

0000000000000420 <strlen>:

uint
strlen(const char *s)
{
 420:	1141                	addi	sp,sp,-16
 422:	e422                	sd	s0,8(sp)
 424:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 426:	00054783          	lbu	a5,0(a0)
 42a:	cf91                	beqz	a5,446 <strlen+0x26>
 42c:	0505                	addi	a0,a0,1
 42e:	87aa                	mv	a5,a0
 430:	4685                	li	a3,1
 432:	9e89                	subw	a3,a3,a0
 434:	00f6853b          	addw	a0,a3,a5
 438:	0785                	addi	a5,a5,1
 43a:	fff7c703          	lbu	a4,-1(a5)
 43e:	fb7d                	bnez	a4,434 <strlen+0x14>
    ;
  return n;
}
 440:	6422                	ld	s0,8(sp)
 442:	0141                	addi	sp,sp,16
 444:	8082                	ret
  for(n = 0; s[n]; n++)
 446:	4501                	li	a0,0
 448:	bfe5                	j	440 <strlen+0x20>

000000000000044a <memset>:

void*
memset(void *dst, int c, uint n)
{
 44a:	1141                	addi	sp,sp,-16
 44c:	e422                	sd	s0,8(sp)
 44e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 450:	ce09                	beqz	a2,46a <memset+0x20>
 452:	87aa                	mv	a5,a0
 454:	fff6071b          	addiw	a4,a2,-1
 458:	1702                	slli	a4,a4,0x20
 45a:	9301                	srli	a4,a4,0x20
 45c:	0705                	addi	a4,a4,1
 45e:	972a                	add	a4,a4,a0
    cdst[i] = c;
 460:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 464:	0785                	addi	a5,a5,1
 466:	fee79de3          	bne	a5,a4,460 <memset+0x16>
  }
  return dst;
}
 46a:	6422                	ld	s0,8(sp)
 46c:	0141                	addi	sp,sp,16
 46e:	8082                	ret

0000000000000470 <strchr>:

char*
strchr(const char *s, char c)
{
 470:	1141                	addi	sp,sp,-16
 472:	e422                	sd	s0,8(sp)
 474:	0800                	addi	s0,sp,16
  for(; *s; s++)
 476:	00054783          	lbu	a5,0(a0)
 47a:	cb99                	beqz	a5,490 <strchr+0x20>
    if(*s == c)
 47c:	00f58763          	beq	a1,a5,48a <strchr+0x1a>
  for(; *s; s++)
 480:	0505                	addi	a0,a0,1
 482:	00054783          	lbu	a5,0(a0)
 486:	fbfd                	bnez	a5,47c <strchr+0xc>
      return (char*)s;
  return 0;
 488:	4501                	li	a0,0
}
 48a:	6422                	ld	s0,8(sp)
 48c:	0141                	addi	sp,sp,16
 48e:	8082                	ret
  return 0;
 490:	4501                	li	a0,0
 492:	bfe5                	j	48a <strchr+0x1a>

0000000000000494 <gets>:

char*
gets(char *buf, int max)
{
 494:	711d                	addi	sp,sp,-96
 496:	ec86                	sd	ra,88(sp)
 498:	e8a2                	sd	s0,80(sp)
 49a:	e4a6                	sd	s1,72(sp)
 49c:	e0ca                	sd	s2,64(sp)
 49e:	fc4e                	sd	s3,56(sp)
 4a0:	f852                	sd	s4,48(sp)
 4a2:	f456                	sd	s5,40(sp)
 4a4:	f05a                	sd	s6,32(sp)
 4a6:	ec5e                	sd	s7,24(sp)
 4a8:	1080                	addi	s0,sp,96
 4aa:	8baa                	mv	s7,a0
 4ac:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4ae:	892a                	mv	s2,a0
 4b0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 4b2:	4aa9                	li	s5,10
 4b4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 4b6:	89a6                	mv	s3,s1
 4b8:	2485                	addiw	s1,s1,1
 4ba:	0344d863          	bge	s1,s4,4ea <gets+0x56>
    cc = read(0, &c, 1);
 4be:	4605                	li	a2,1
 4c0:	faf40593          	addi	a1,s0,-81
 4c4:	4501                	li	a0,0
 4c6:	00000097          	auipc	ra,0x0
 4ca:	1a0080e7          	jalr	416(ra) # 666 <read>
    if(cc < 1)
 4ce:	00a05e63          	blez	a0,4ea <gets+0x56>
    buf[i++] = c;
 4d2:	faf44783          	lbu	a5,-81(s0)
 4d6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 4da:	01578763          	beq	a5,s5,4e8 <gets+0x54>
 4de:	0905                	addi	s2,s2,1
 4e0:	fd679be3          	bne	a5,s6,4b6 <gets+0x22>
  for(i=0; i+1 < max; ){
 4e4:	89a6                	mv	s3,s1
 4e6:	a011                	j	4ea <gets+0x56>
 4e8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 4ea:	99de                	add	s3,s3,s7
 4ec:	00098023          	sb	zero,0(s3) # 1000 <freep>
  return buf;
}
 4f0:	855e                	mv	a0,s7
 4f2:	60e6                	ld	ra,88(sp)
 4f4:	6446                	ld	s0,80(sp)
 4f6:	64a6                	ld	s1,72(sp)
 4f8:	6906                	ld	s2,64(sp)
 4fa:	79e2                	ld	s3,56(sp)
 4fc:	7a42                	ld	s4,48(sp)
 4fe:	7aa2                	ld	s5,40(sp)
 500:	7b02                	ld	s6,32(sp)
 502:	6be2                	ld	s7,24(sp)
 504:	6125                	addi	sp,sp,96
 506:	8082                	ret

0000000000000508 <stat>:

int
stat(const char *n, struct stat *st)
{
 508:	1101                	addi	sp,sp,-32
 50a:	ec06                	sd	ra,24(sp)
 50c:	e822                	sd	s0,16(sp)
 50e:	e426                	sd	s1,8(sp)
 510:	e04a                	sd	s2,0(sp)
 512:	1000                	addi	s0,sp,32
 514:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 516:	4581                	li	a1,0
 518:	00000097          	auipc	ra,0x0
 51c:	176080e7          	jalr	374(ra) # 68e <open>
  if(fd < 0)
 520:	02054563          	bltz	a0,54a <stat+0x42>
 524:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 526:	85ca                	mv	a1,s2
 528:	00000097          	auipc	ra,0x0
 52c:	17e080e7          	jalr	382(ra) # 6a6 <fstat>
 530:	892a                	mv	s2,a0
  close(fd);
 532:	8526                	mv	a0,s1
 534:	00000097          	auipc	ra,0x0
 538:	142080e7          	jalr	322(ra) # 676 <close>
  return r;
}
 53c:	854a                	mv	a0,s2
 53e:	60e2                	ld	ra,24(sp)
 540:	6442                	ld	s0,16(sp)
 542:	64a2                	ld	s1,8(sp)
 544:	6902                	ld	s2,0(sp)
 546:	6105                	addi	sp,sp,32
 548:	8082                	ret
    return -1;
 54a:	597d                	li	s2,-1
 54c:	bfc5                	j	53c <stat+0x34>

000000000000054e <atoi>:

int
atoi(const char *s)
{
 54e:	1141                	addi	sp,sp,-16
 550:	e422                	sd	s0,8(sp)
 552:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 554:	00054603          	lbu	a2,0(a0)
 558:	fd06079b          	addiw	a5,a2,-48
 55c:	0ff7f793          	andi	a5,a5,255
 560:	4725                	li	a4,9
 562:	02f76963          	bltu	a4,a5,594 <atoi+0x46>
 566:	86aa                	mv	a3,a0
  n = 0;
 568:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 56a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 56c:	0685                	addi	a3,a3,1
 56e:	0025179b          	slliw	a5,a0,0x2
 572:	9fa9                	addw	a5,a5,a0
 574:	0017979b          	slliw	a5,a5,0x1
 578:	9fb1                	addw	a5,a5,a2
 57a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 57e:	0006c603          	lbu	a2,0(a3)
 582:	fd06071b          	addiw	a4,a2,-48
 586:	0ff77713          	andi	a4,a4,255
 58a:	fee5f1e3          	bgeu	a1,a4,56c <atoi+0x1e>
  return n;
}
 58e:	6422                	ld	s0,8(sp)
 590:	0141                	addi	sp,sp,16
 592:	8082                	ret
  n = 0;
 594:	4501                	li	a0,0
 596:	bfe5                	j	58e <atoi+0x40>

0000000000000598 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 598:	1141                	addi	sp,sp,-16
 59a:	e422                	sd	s0,8(sp)
 59c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 59e:	02b57663          	bgeu	a0,a1,5ca <memmove+0x32>
    while(n-- > 0)
 5a2:	02c05163          	blez	a2,5c4 <memmove+0x2c>
 5a6:	fff6079b          	addiw	a5,a2,-1
 5aa:	1782                	slli	a5,a5,0x20
 5ac:	9381                	srli	a5,a5,0x20
 5ae:	0785                	addi	a5,a5,1
 5b0:	97aa                	add	a5,a5,a0
  dst = vdst;
 5b2:	872a                	mv	a4,a0
      *dst++ = *src++;
 5b4:	0585                	addi	a1,a1,1
 5b6:	0705                	addi	a4,a4,1
 5b8:	fff5c683          	lbu	a3,-1(a1)
 5bc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 5c0:	fee79ae3          	bne	a5,a4,5b4 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 5c4:	6422                	ld	s0,8(sp)
 5c6:	0141                	addi	sp,sp,16
 5c8:	8082                	ret
    dst += n;
 5ca:	00c50733          	add	a4,a0,a2
    src += n;
 5ce:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 5d0:	fec05ae3          	blez	a2,5c4 <memmove+0x2c>
 5d4:	fff6079b          	addiw	a5,a2,-1
 5d8:	1782                	slli	a5,a5,0x20
 5da:	9381                	srli	a5,a5,0x20
 5dc:	fff7c793          	not	a5,a5
 5e0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 5e2:	15fd                	addi	a1,a1,-1
 5e4:	177d                	addi	a4,a4,-1
 5e6:	0005c683          	lbu	a3,0(a1)
 5ea:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 5ee:	fee79ae3          	bne	a5,a4,5e2 <memmove+0x4a>
 5f2:	bfc9                	j	5c4 <memmove+0x2c>

00000000000005f4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 5f4:	1141                	addi	sp,sp,-16
 5f6:	e422                	sd	s0,8(sp)
 5f8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 5fa:	ca05                	beqz	a2,62a <memcmp+0x36>
 5fc:	fff6069b          	addiw	a3,a2,-1
 600:	1682                	slli	a3,a3,0x20
 602:	9281                	srli	a3,a3,0x20
 604:	0685                	addi	a3,a3,1
 606:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 608:	00054783          	lbu	a5,0(a0)
 60c:	0005c703          	lbu	a4,0(a1)
 610:	00e79863          	bne	a5,a4,620 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 614:	0505                	addi	a0,a0,1
    p2++;
 616:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 618:	fed518e3          	bne	a0,a3,608 <memcmp+0x14>
  }
  return 0;
 61c:	4501                	li	a0,0
 61e:	a019                	j	624 <memcmp+0x30>
      return *p1 - *p2;
 620:	40e7853b          	subw	a0,a5,a4
}
 624:	6422                	ld	s0,8(sp)
 626:	0141                	addi	sp,sp,16
 628:	8082                	ret
  return 0;
 62a:	4501                	li	a0,0
 62c:	bfe5                	j	624 <memcmp+0x30>

000000000000062e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 62e:	1141                	addi	sp,sp,-16
 630:	e406                	sd	ra,8(sp)
 632:	e022                	sd	s0,0(sp)
 634:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 636:	00000097          	auipc	ra,0x0
 63a:	f62080e7          	jalr	-158(ra) # 598 <memmove>
}
 63e:	60a2                	ld	ra,8(sp)
 640:	6402                	ld	s0,0(sp)
 642:	0141                	addi	sp,sp,16
 644:	8082                	ret

0000000000000646 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 646:	4885                	li	a7,1
 ecall
 648:	00000073          	ecall
 ret
 64c:	8082                	ret

000000000000064e <exit>:
.global exit
exit:
 li a7, SYS_exit
 64e:	4889                	li	a7,2
 ecall
 650:	00000073          	ecall
 ret
 654:	8082                	ret

0000000000000656 <wait>:
.global wait
wait:
 li a7, SYS_wait
 656:	488d                	li	a7,3
 ecall
 658:	00000073          	ecall
 ret
 65c:	8082                	ret

000000000000065e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 65e:	4891                	li	a7,4
 ecall
 660:	00000073          	ecall
 ret
 664:	8082                	ret

0000000000000666 <read>:
.global read
read:
 li a7, SYS_read
 666:	4895                	li	a7,5
 ecall
 668:	00000073          	ecall
 ret
 66c:	8082                	ret

000000000000066e <write>:
.global write
write:
 li a7, SYS_write
 66e:	48c1                	li	a7,16
 ecall
 670:	00000073          	ecall
 ret
 674:	8082                	ret

0000000000000676 <close>:
.global close
close:
 li a7, SYS_close
 676:	48d5                	li	a7,21
 ecall
 678:	00000073          	ecall
 ret
 67c:	8082                	ret

000000000000067e <kill>:
.global kill
kill:
 li a7, SYS_kill
 67e:	4899                	li	a7,6
 ecall
 680:	00000073          	ecall
 ret
 684:	8082                	ret

0000000000000686 <exec>:
.global exec
exec:
 li a7, SYS_exec
 686:	489d                	li	a7,7
 ecall
 688:	00000073          	ecall
 ret
 68c:	8082                	ret

000000000000068e <open>:
.global open
open:
 li a7, SYS_open
 68e:	48bd                	li	a7,15
 ecall
 690:	00000073          	ecall
 ret
 694:	8082                	ret

0000000000000696 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 696:	48c5                	li	a7,17
 ecall
 698:	00000073          	ecall
 ret
 69c:	8082                	ret

000000000000069e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 69e:	48c9                	li	a7,18
 ecall
 6a0:	00000073          	ecall
 ret
 6a4:	8082                	ret

00000000000006a6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 6a6:	48a1                	li	a7,8
 ecall
 6a8:	00000073          	ecall
 ret
 6ac:	8082                	ret

00000000000006ae <link>:
.global link
link:
 li a7, SYS_link
 6ae:	48cd                	li	a7,19
 ecall
 6b0:	00000073          	ecall
 ret
 6b4:	8082                	ret

00000000000006b6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 6b6:	48d1                	li	a7,20
 ecall
 6b8:	00000073          	ecall
 ret
 6bc:	8082                	ret

00000000000006be <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6be:	48a5                	li	a7,9
 ecall
 6c0:	00000073          	ecall
 ret
 6c4:	8082                	ret

00000000000006c6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 6c6:	48a9                	li	a7,10
 ecall
 6c8:	00000073          	ecall
 ret
 6cc:	8082                	ret

00000000000006ce <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6ce:	48ad                	li	a7,11
 ecall
 6d0:	00000073          	ecall
 ret
 6d4:	8082                	ret

00000000000006d6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6d6:	48b1                	li	a7,12
 ecall
 6d8:	00000073          	ecall
 ret
 6dc:	8082                	ret

00000000000006de <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6de:	48b5                	li	a7,13
 ecall
 6e0:	00000073          	ecall
 ret
 6e4:	8082                	ret

00000000000006e6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6e6:	48b9                	li	a7,14
 ecall
 6e8:	00000073          	ecall
 ret
 6ec:	8082                	ret

00000000000006ee <trace>:
.global trace
trace:
 li a7, SYS_trace
 6ee:	48d9                	li	a7,22
 ecall
 6f0:	00000073          	ecall
 ret
 6f4:	8082                	ret

00000000000006f6 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 6f6:	48dd                	li	a7,23
 ecall
 6f8:	00000073          	ecall
 ret
 6fc:	8082                	ret

00000000000006fe <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6fe:	1101                	addi	sp,sp,-32
 700:	ec06                	sd	ra,24(sp)
 702:	e822                	sd	s0,16(sp)
 704:	1000                	addi	s0,sp,32
 706:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 70a:	4605                	li	a2,1
 70c:	fef40593          	addi	a1,s0,-17
 710:	00000097          	auipc	ra,0x0
 714:	f5e080e7          	jalr	-162(ra) # 66e <write>
}
 718:	60e2                	ld	ra,24(sp)
 71a:	6442                	ld	s0,16(sp)
 71c:	6105                	addi	sp,sp,32
 71e:	8082                	ret

0000000000000720 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 720:	7139                	addi	sp,sp,-64
 722:	fc06                	sd	ra,56(sp)
 724:	f822                	sd	s0,48(sp)
 726:	f426                	sd	s1,40(sp)
 728:	f04a                	sd	s2,32(sp)
 72a:	ec4e                	sd	s3,24(sp)
 72c:	0080                	addi	s0,sp,64
 72e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 730:	c299                	beqz	a3,736 <printint+0x16>
 732:	0805c863          	bltz	a1,7c2 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 736:	2581                	sext.w	a1,a1
  neg = 0;
 738:	4881                	li	a7,0
 73a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 73e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 740:	2601                	sext.w	a2,a2
 742:	00000517          	auipc	a0,0x0
 746:	5d650513          	addi	a0,a0,1494 # d18 <digits>
 74a:	883a                	mv	a6,a4
 74c:	2705                	addiw	a4,a4,1
 74e:	02c5f7bb          	remuw	a5,a1,a2
 752:	1782                	slli	a5,a5,0x20
 754:	9381                	srli	a5,a5,0x20
 756:	97aa                	add	a5,a5,a0
 758:	0007c783          	lbu	a5,0(a5)
 75c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 760:	0005879b          	sext.w	a5,a1
 764:	02c5d5bb          	divuw	a1,a1,a2
 768:	0685                	addi	a3,a3,1
 76a:	fec7f0e3          	bgeu	a5,a2,74a <printint+0x2a>
  if(neg)
 76e:	00088b63          	beqz	a7,784 <printint+0x64>
    buf[i++] = '-';
 772:	fd040793          	addi	a5,s0,-48
 776:	973e                	add	a4,a4,a5
 778:	02d00793          	li	a5,45
 77c:	fef70823          	sb	a5,-16(a4)
 780:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 784:	02e05863          	blez	a4,7b4 <printint+0x94>
 788:	fc040793          	addi	a5,s0,-64
 78c:	00e78933          	add	s2,a5,a4
 790:	fff78993          	addi	s3,a5,-1
 794:	99ba                	add	s3,s3,a4
 796:	377d                	addiw	a4,a4,-1
 798:	1702                	slli	a4,a4,0x20
 79a:	9301                	srli	a4,a4,0x20
 79c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 7a0:	fff94583          	lbu	a1,-1(s2)
 7a4:	8526                	mv	a0,s1
 7a6:	00000097          	auipc	ra,0x0
 7aa:	f58080e7          	jalr	-168(ra) # 6fe <putc>
  while(--i >= 0)
 7ae:	197d                	addi	s2,s2,-1
 7b0:	ff3918e3          	bne	s2,s3,7a0 <printint+0x80>
}
 7b4:	70e2                	ld	ra,56(sp)
 7b6:	7442                	ld	s0,48(sp)
 7b8:	74a2                	ld	s1,40(sp)
 7ba:	7902                	ld	s2,32(sp)
 7bc:	69e2                	ld	s3,24(sp)
 7be:	6121                	addi	sp,sp,64
 7c0:	8082                	ret
    x = -xx;
 7c2:	40b005bb          	negw	a1,a1
    neg = 1;
 7c6:	4885                	li	a7,1
    x = -xx;
 7c8:	bf8d                	j	73a <printint+0x1a>

00000000000007ca <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7ca:	7119                	addi	sp,sp,-128
 7cc:	fc86                	sd	ra,120(sp)
 7ce:	f8a2                	sd	s0,112(sp)
 7d0:	f4a6                	sd	s1,104(sp)
 7d2:	f0ca                	sd	s2,96(sp)
 7d4:	ecce                	sd	s3,88(sp)
 7d6:	e8d2                	sd	s4,80(sp)
 7d8:	e4d6                	sd	s5,72(sp)
 7da:	e0da                	sd	s6,64(sp)
 7dc:	fc5e                	sd	s7,56(sp)
 7de:	f862                	sd	s8,48(sp)
 7e0:	f466                	sd	s9,40(sp)
 7e2:	f06a                	sd	s10,32(sp)
 7e4:	ec6e                	sd	s11,24(sp)
 7e6:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7e8:	0005c903          	lbu	s2,0(a1)
 7ec:	18090f63          	beqz	s2,98a <vprintf+0x1c0>
 7f0:	8aaa                	mv	s5,a0
 7f2:	8b32                	mv	s6,a2
 7f4:	00158493          	addi	s1,a1,1
  state = 0;
 7f8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7fa:	02500a13          	li	s4,37
      if(c == 'd'){
 7fe:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 802:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 806:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 80a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 80e:	00000b97          	auipc	s7,0x0
 812:	50ab8b93          	addi	s7,s7,1290 # d18 <digits>
 816:	a839                	j	834 <vprintf+0x6a>
        putc(fd, c);
 818:	85ca                	mv	a1,s2
 81a:	8556                	mv	a0,s5
 81c:	00000097          	auipc	ra,0x0
 820:	ee2080e7          	jalr	-286(ra) # 6fe <putc>
 824:	a019                	j	82a <vprintf+0x60>
    } else if(state == '%'){
 826:	01498f63          	beq	s3,s4,844 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 82a:	0485                	addi	s1,s1,1
 82c:	fff4c903          	lbu	s2,-1(s1)
 830:	14090d63          	beqz	s2,98a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 834:	0009079b          	sext.w	a5,s2
    if(state == 0){
 838:	fe0997e3          	bnez	s3,826 <vprintf+0x5c>
      if(c == '%'){
 83c:	fd479ee3          	bne	a5,s4,818 <vprintf+0x4e>
        state = '%';
 840:	89be                	mv	s3,a5
 842:	b7e5                	j	82a <vprintf+0x60>
      if(c == 'd'){
 844:	05878063          	beq	a5,s8,884 <vprintf+0xba>
      } else if(c == 'l') {
 848:	05978c63          	beq	a5,s9,8a0 <vprintf+0xd6>
      } else if(c == 'x') {
 84c:	07a78863          	beq	a5,s10,8bc <vprintf+0xf2>
      } else if(c == 'p') {
 850:	09b78463          	beq	a5,s11,8d8 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 854:	07300713          	li	a4,115
 858:	0ce78663          	beq	a5,a4,924 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 85c:	06300713          	li	a4,99
 860:	0ee78e63          	beq	a5,a4,95c <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 864:	11478863          	beq	a5,s4,974 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 868:	85d2                	mv	a1,s4
 86a:	8556                	mv	a0,s5
 86c:	00000097          	auipc	ra,0x0
 870:	e92080e7          	jalr	-366(ra) # 6fe <putc>
        putc(fd, c);
 874:	85ca                	mv	a1,s2
 876:	8556                	mv	a0,s5
 878:	00000097          	auipc	ra,0x0
 87c:	e86080e7          	jalr	-378(ra) # 6fe <putc>
      }
      state = 0;
 880:	4981                	li	s3,0
 882:	b765                	j	82a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 884:	008b0913          	addi	s2,s6,8
 888:	4685                	li	a3,1
 88a:	4629                	li	a2,10
 88c:	000b2583          	lw	a1,0(s6)
 890:	8556                	mv	a0,s5
 892:	00000097          	auipc	ra,0x0
 896:	e8e080e7          	jalr	-370(ra) # 720 <printint>
 89a:	8b4a                	mv	s6,s2
      state = 0;
 89c:	4981                	li	s3,0
 89e:	b771                	j	82a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8a0:	008b0913          	addi	s2,s6,8
 8a4:	4681                	li	a3,0
 8a6:	4629                	li	a2,10
 8a8:	000b2583          	lw	a1,0(s6)
 8ac:	8556                	mv	a0,s5
 8ae:	00000097          	auipc	ra,0x0
 8b2:	e72080e7          	jalr	-398(ra) # 720 <printint>
 8b6:	8b4a                	mv	s6,s2
      state = 0;
 8b8:	4981                	li	s3,0
 8ba:	bf85                	j	82a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 8bc:	008b0913          	addi	s2,s6,8
 8c0:	4681                	li	a3,0
 8c2:	4641                	li	a2,16
 8c4:	000b2583          	lw	a1,0(s6)
 8c8:	8556                	mv	a0,s5
 8ca:	00000097          	auipc	ra,0x0
 8ce:	e56080e7          	jalr	-426(ra) # 720 <printint>
 8d2:	8b4a                	mv	s6,s2
      state = 0;
 8d4:	4981                	li	s3,0
 8d6:	bf91                	j	82a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 8d8:	008b0793          	addi	a5,s6,8
 8dc:	f8f43423          	sd	a5,-120(s0)
 8e0:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 8e4:	03000593          	li	a1,48
 8e8:	8556                	mv	a0,s5
 8ea:	00000097          	auipc	ra,0x0
 8ee:	e14080e7          	jalr	-492(ra) # 6fe <putc>
  putc(fd, 'x');
 8f2:	85ea                	mv	a1,s10
 8f4:	8556                	mv	a0,s5
 8f6:	00000097          	auipc	ra,0x0
 8fa:	e08080e7          	jalr	-504(ra) # 6fe <putc>
 8fe:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 900:	03c9d793          	srli	a5,s3,0x3c
 904:	97de                	add	a5,a5,s7
 906:	0007c583          	lbu	a1,0(a5)
 90a:	8556                	mv	a0,s5
 90c:	00000097          	auipc	ra,0x0
 910:	df2080e7          	jalr	-526(ra) # 6fe <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 914:	0992                	slli	s3,s3,0x4
 916:	397d                	addiw	s2,s2,-1
 918:	fe0914e3          	bnez	s2,900 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 91c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 920:	4981                	li	s3,0
 922:	b721                	j	82a <vprintf+0x60>
        s = va_arg(ap, char*);
 924:	008b0993          	addi	s3,s6,8
 928:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 92c:	02090163          	beqz	s2,94e <vprintf+0x184>
        while(*s != 0){
 930:	00094583          	lbu	a1,0(s2)
 934:	c9a1                	beqz	a1,984 <vprintf+0x1ba>
          putc(fd, *s);
 936:	8556                	mv	a0,s5
 938:	00000097          	auipc	ra,0x0
 93c:	dc6080e7          	jalr	-570(ra) # 6fe <putc>
          s++;
 940:	0905                	addi	s2,s2,1
        while(*s != 0){
 942:	00094583          	lbu	a1,0(s2)
 946:	f9e5                	bnez	a1,936 <vprintf+0x16c>
        s = va_arg(ap, char*);
 948:	8b4e                	mv	s6,s3
      state = 0;
 94a:	4981                	li	s3,0
 94c:	bdf9                	j	82a <vprintf+0x60>
          s = "(null)";
 94e:	00000917          	auipc	s2,0x0
 952:	3c290913          	addi	s2,s2,962 # d10 <malloc+0x27c>
        while(*s != 0){
 956:	02800593          	li	a1,40
 95a:	bff1                	j	936 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 95c:	008b0913          	addi	s2,s6,8
 960:	000b4583          	lbu	a1,0(s6)
 964:	8556                	mv	a0,s5
 966:	00000097          	auipc	ra,0x0
 96a:	d98080e7          	jalr	-616(ra) # 6fe <putc>
 96e:	8b4a                	mv	s6,s2
      state = 0;
 970:	4981                	li	s3,0
 972:	bd65                	j	82a <vprintf+0x60>
        putc(fd, c);
 974:	85d2                	mv	a1,s4
 976:	8556                	mv	a0,s5
 978:	00000097          	auipc	ra,0x0
 97c:	d86080e7          	jalr	-634(ra) # 6fe <putc>
      state = 0;
 980:	4981                	li	s3,0
 982:	b565                	j	82a <vprintf+0x60>
        s = va_arg(ap, char*);
 984:	8b4e                	mv	s6,s3
      state = 0;
 986:	4981                	li	s3,0
 988:	b54d                	j	82a <vprintf+0x60>
    }
  }
}
 98a:	70e6                	ld	ra,120(sp)
 98c:	7446                	ld	s0,112(sp)
 98e:	74a6                	ld	s1,104(sp)
 990:	7906                	ld	s2,96(sp)
 992:	69e6                	ld	s3,88(sp)
 994:	6a46                	ld	s4,80(sp)
 996:	6aa6                	ld	s5,72(sp)
 998:	6b06                	ld	s6,64(sp)
 99a:	7be2                	ld	s7,56(sp)
 99c:	7c42                	ld	s8,48(sp)
 99e:	7ca2                	ld	s9,40(sp)
 9a0:	7d02                	ld	s10,32(sp)
 9a2:	6de2                	ld	s11,24(sp)
 9a4:	6109                	addi	sp,sp,128
 9a6:	8082                	ret

00000000000009a8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9a8:	715d                	addi	sp,sp,-80
 9aa:	ec06                	sd	ra,24(sp)
 9ac:	e822                	sd	s0,16(sp)
 9ae:	1000                	addi	s0,sp,32
 9b0:	e010                	sd	a2,0(s0)
 9b2:	e414                	sd	a3,8(s0)
 9b4:	e818                	sd	a4,16(s0)
 9b6:	ec1c                	sd	a5,24(s0)
 9b8:	03043023          	sd	a6,32(s0)
 9bc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9c0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9c4:	8622                	mv	a2,s0
 9c6:	00000097          	auipc	ra,0x0
 9ca:	e04080e7          	jalr	-508(ra) # 7ca <vprintf>
}
 9ce:	60e2                	ld	ra,24(sp)
 9d0:	6442                	ld	s0,16(sp)
 9d2:	6161                	addi	sp,sp,80
 9d4:	8082                	ret

00000000000009d6 <printf>:

void
printf(const char *fmt, ...)
{
 9d6:	711d                	addi	sp,sp,-96
 9d8:	ec06                	sd	ra,24(sp)
 9da:	e822                	sd	s0,16(sp)
 9dc:	1000                	addi	s0,sp,32
 9de:	e40c                	sd	a1,8(s0)
 9e0:	e810                	sd	a2,16(s0)
 9e2:	ec14                	sd	a3,24(s0)
 9e4:	f018                	sd	a4,32(s0)
 9e6:	f41c                	sd	a5,40(s0)
 9e8:	03043823          	sd	a6,48(s0)
 9ec:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9f0:	00840613          	addi	a2,s0,8
 9f4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9f8:	85aa                	mv	a1,a0
 9fa:	4505                	li	a0,1
 9fc:	00000097          	auipc	ra,0x0
 a00:	dce080e7          	jalr	-562(ra) # 7ca <vprintf>
}
 a04:	60e2                	ld	ra,24(sp)
 a06:	6442                	ld	s0,16(sp)
 a08:	6125                	addi	sp,sp,96
 a0a:	8082                	ret

0000000000000a0c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a0c:	1141                	addi	sp,sp,-16
 a0e:	e422                	sd	s0,8(sp)
 a10:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a12:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a16:	00000797          	auipc	a5,0x0
 a1a:	5ea7b783          	ld	a5,1514(a5) # 1000 <freep>
 a1e:	a805                	j	a4e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a20:	4618                	lw	a4,8(a2)
 a22:	9db9                	addw	a1,a1,a4
 a24:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a28:	6398                	ld	a4,0(a5)
 a2a:	6318                	ld	a4,0(a4)
 a2c:	fee53823          	sd	a4,-16(a0)
 a30:	a091                	j	a74 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a32:	ff852703          	lw	a4,-8(a0)
 a36:	9e39                	addw	a2,a2,a4
 a38:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 a3a:	ff053703          	ld	a4,-16(a0)
 a3e:	e398                	sd	a4,0(a5)
 a40:	a099                	j	a86 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a42:	6398                	ld	a4,0(a5)
 a44:	00e7e463          	bltu	a5,a4,a4c <free+0x40>
 a48:	00e6ea63          	bltu	a3,a4,a5c <free+0x50>
{
 a4c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a4e:	fed7fae3          	bgeu	a5,a3,a42 <free+0x36>
 a52:	6398                	ld	a4,0(a5)
 a54:	00e6e463          	bltu	a3,a4,a5c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a58:	fee7eae3          	bltu	a5,a4,a4c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 a5c:	ff852583          	lw	a1,-8(a0)
 a60:	6390                	ld	a2,0(a5)
 a62:	02059713          	slli	a4,a1,0x20
 a66:	9301                	srli	a4,a4,0x20
 a68:	0712                	slli	a4,a4,0x4
 a6a:	9736                	add	a4,a4,a3
 a6c:	fae60ae3          	beq	a2,a4,a20 <free+0x14>
    bp->s.ptr = p->s.ptr;
 a70:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a74:	4790                	lw	a2,8(a5)
 a76:	02061713          	slli	a4,a2,0x20
 a7a:	9301                	srli	a4,a4,0x20
 a7c:	0712                	slli	a4,a4,0x4
 a7e:	973e                	add	a4,a4,a5
 a80:	fae689e3          	beq	a3,a4,a32 <free+0x26>
  } else
    p->s.ptr = bp;
 a84:	e394                	sd	a3,0(a5)
  freep = p;
 a86:	00000717          	auipc	a4,0x0
 a8a:	56f73d23          	sd	a5,1402(a4) # 1000 <freep>
}
 a8e:	6422                	ld	s0,8(sp)
 a90:	0141                	addi	sp,sp,16
 a92:	8082                	ret

0000000000000a94 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a94:	7139                	addi	sp,sp,-64
 a96:	fc06                	sd	ra,56(sp)
 a98:	f822                	sd	s0,48(sp)
 a9a:	f426                	sd	s1,40(sp)
 a9c:	f04a                	sd	s2,32(sp)
 a9e:	ec4e                	sd	s3,24(sp)
 aa0:	e852                	sd	s4,16(sp)
 aa2:	e456                	sd	s5,8(sp)
 aa4:	e05a                	sd	s6,0(sp)
 aa6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 aa8:	02051493          	slli	s1,a0,0x20
 aac:	9081                	srli	s1,s1,0x20
 aae:	04bd                	addi	s1,s1,15
 ab0:	8091                	srli	s1,s1,0x4
 ab2:	0014899b          	addiw	s3,s1,1
 ab6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 ab8:	00000517          	auipc	a0,0x0
 abc:	54853503          	ld	a0,1352(a0) # 1000 <freep>
 ac0:	c515                	beqz	a0,aec <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ac2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ac4:	4798                	lw	a4,8(a5)
 ac6:	02977f63          	bgeu	a4,s1,b04 <malloc+0x70>
 aca:	8a4e                	mv	s4,s3
 acc:	0009871b          	sext.w	a4,s3
 ad0:	6685                	lui	a3,0x1
 ad2:	00d77363          	bgeu	a4,a3,ad8 <malloc+0x44>
 ad6:	6a05                	lui	s4,0x1
 ad8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 adc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ae0:	00000917          	auipc	s2,0x0
 ae4:	52090913          	addi	s2,s2,1312 # 1000 <freep>
  if(p == (char*)-1)
 ae8:	5afd                	li	s5,-1
 aea:	a88d                	j	b5c <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 aec:	00000797          	auipc	a5,0x0
 af0:	52478793          	addi	a5,a5,1316 # 1010 <base>
 af4:	00000717          	auipc	a4,0x0
 af8:	50f73623          	sd	a5,1292(a4) # 1000 <freep>
 afc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 afe:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b02:	b7e1                	j	aca <malloc+0x36>
      if(p->s.size == nunits)
 b04:	02e48b63          	beq	s1,a4,b3a <malloc+0xa6>
        p->s.size -= nunits;
 b08:	4137073b          	subw	a4,a4,s3
 b0c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b0e:	1702                	slli	a4,a4,0x20
 b10:	9301                	srli	a4,a4,0x20
 b12:	0712                	slli	a4,a4,0x4
 b14:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b16:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b1a:	00000717          	auipc	a4,0x0
 b1e:	4ea73323          	sd	a0,1254(a4) # 1000 <freep>
      return (void*)(p + 1);
 b22:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 b26:	70e2                	ld	ra,56(sp)
 b28:	7442                	ld	s0,48(sp)
 b2a:	74a2                	ld	s1,40(sp)
 b2c:	7902                	ld	s2,32(sp)
 b2e:	69e2                	ld	s3,24(sp)
 b30:	6a42                	ld	s4,16(sp)
 b32:	6aa2                	ld	s5,8(sp)
 b34:	6b02                	ld	s6,0(sp)
 b36:	6121                	addi	sp,sp,64
 b38:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 b3a:	6398                	ld	a4,0(a5)
 b3c:	e118                	sd	a4,0(a0)
 b3e:	bff1                	j	b1a <malloc+0x86>
  hp->s.size = nu;
 b40:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b44:	0541                	addi	a0,a0,16
 b46:	00000097          	auipc	ra,0x0
 b4a:	ec6080e7          	jalr	-314(ra) # a0c <free>
  return freep;
 b4e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b52:	d971                	beqz	a0,b26 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b54:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b56:	4798                	lw	a4,8(a5)
 b58:	fa9776e3          	bgeu	a4,s1,b04 <malloc+0x70>
    if(p == freep)
 b5c:	00093703          	ld	a4,0(s2)
 b60:	853e                	mv	a0,a5
 b62:	fef719e3          	bne	a4,a5,b54 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 b66:	8552                	mv	a0,s4
 b68:	00000097          	auipc	ra,0x0
 b6c:	b6e080e7          	jalr	-1170(ra) # 6d6 <sbrk>
  if(p == (char*)-1)
 b70:	fd5518e3          	bne	a0,s5,b40 <malloc+0xac>
        return 0;
 b74:	4501                	li	a0,0
 b76:	bf45                	j	b26 <malloc+0x92>
