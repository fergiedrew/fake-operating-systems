
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001a117          	auipc	sp,0x1a
    80000004:	db010113          	addi	sp,sp,-592 # 80019db0 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	7f6050ef          	jal	ra,8000580c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00022797          	auipc	a5,0x22
    80000034:	e8078793          	addi	a5,a5,-384 # 80021eb0 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	9f090913          	addi	s2,s2,-1552 # 80008a40 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	1b2080e7          	jalr	434(ra) # 8000620c <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	252080e7          	jalr	594(ra) # 800062c0 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	c38080e7          	jalr	-968(ra) # 80005cc2 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	95450513          	addi	a0,a0,-1708 # 80008a40 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	088080e7          	jalr	136(ra) # 8000617c <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00022517          	auipc	a0,0x22
    80000104:	db050513          	addi	a0,a0,-592 # 80021eb0 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	91e48493          	addi	s1,s1,-1762 # 80008a40 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	0e0080e7          	jalr	224(ra) # 8000620c <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	90650513          	addi	a0,a0,-1786 # 80008a40 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	17c080e7          	jalr	380(ra) # 800062c0 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	8da50513          	addi	a0,a0,-1830 # 80008a40 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	152080e7          	jalr	338(ra) # 800062c0 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ce09                	beqz	a2,80000198 <memset+0x20>
    80000180:	87aa                	mv	a5,a0
    80000182:	fff6071b          	addiw	a4,a2,-1
    80000186:	1702                	slli	a4,a4,0x20
    80000188:	9301                	srli	a4,a4,0x20
    8000018a:	0705                	addi	a4,a4,1
    8000018c:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000018e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000192:	0785                	addi	a5,a5,1
    80000194:	fee79de3          	bne	a5,a4,8000018e <memset+0x16>
  }
  return dst;
}
    80000198:	6422                	ld	s0,8(sp)
    8000019a:	0141                	addi	sp,sp,16
    8000019c:	8082                	ret

000000008000019e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a4:	ca05                	beqz	a2,800001d4 <memcmp+0x36>
    800001a6:	fff6069b          	addiw	a3,a2,-1
    800001aa:	1682                	slli	a3,a3,0x20
    800001ac:	9281                	srli	a3,a3,0x20
    800001ae:	0685                	addi	a3,a3,1
    800001b0:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b2:	00054783          	lbu	a5,0(a0)
    800001b6:	0005c703          	lbu	a4,0(a1)
    800001ba:	00e79863          	bne	a5,a4,800001ca <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001be:	0505                	addi	a0,a0,1
    800001c0:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c2:	fed518e3          	bne	a0,a3,800001b2 <memcmp+0x14>
  }

  return 0;
    800001c6:	4501                	li	a0,0
    800001c8:	a019                	j	800001ce <memcmp+0x30>
      return *s1 - *s2;
    800001ca:	40e7853b          	subw	a0,a5,a4
}
    800001ce:	6422                	ld	s0,8(sp)
    800001d0:	0141                	addi	sp,sp,16
    800001d2:	8082                	ret
  return 0;
    800001d4:	4501                	li	a0,0
    800001d6:	bfe5                	j	800001ce <memcmp+0x30>

00000000800001d8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d8:	1141                	addi	sp,sp,-16
    800001da:	e422                	sd	s0,8(sp)
    800001dc:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001de:	ca0d                	beqz	a2,80000210 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001e0:	00a5f963          	bgeu	a1,a0,800001f2 <memmove+0x1a>
    800001e4:	02061693          	slli	a3,a2,0x20
    800001e8:	9281                	srli	a3,a3,0x20
    800001ea:	00d58733          	add	a4,a1,a3
    800001ee:	02e56463          	bltu	a0,a4,80000216 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	0785                	addi	a5,a5,1
    800001fc:	97ae                	add	a5,a5,a1
    800001fe:	872a                	mv	a4,a0
      *d++ = *s++;
    80000200:	0585                	addi	a1,a1,1
    80000202:	0705                	addi	a4,a4,1
    80000204:	fff5c683          	lbu	a3,-1(a1)
    80000208:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000020c:	fef59ae3          	bne	a1,a5,80000200 <memmove+0x28>

  return dst;
}
    80000210:	6422                	ld	s0,8(sp)
    80000212:	0141                	addi	sp,sp,16
    80000214:	8082                	ret
    d += n;
    80000216:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000218:	fff6079b          	addiw	a5,a2,-1
    8000021c:	1782                	slli	a5,a5,0x20
    8000021e:	9381                	srli	a5,a5,0x20
    80000220:	fff7c793          	not	a5,a5
    80000224:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000226:	177d                	addi	a4,a4,-1
    80000228:	16fd                	addi	a3,a3,-1
    8000022a:	00074603          	lbu	a2,0(a4)
    8000022e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000232:	fef71ae3          	bne	a4,a5,80000226 <memmove+0x4e>
    80000236:	bfe9                	j	80000210 <memmove+0x38>

0000000080000238 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000238:	1141                	addi	sp,sp,-16
    8000023a:	e406                	sd	ra,8(sp)
    8000023c:	e022                	sd	s0,0(sp)
    8000023e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000240:	00000097          	auipc	ra,0x0
    80000244:	f98080e7          	jalr	-104(ra) # 800001d8 <memmove>
}
    80000248:	60a2                	ld	ra,8(sp)
    8000024a:	6402                	ld	s0,0(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000256:	ce11                	beqz	a2,80000272 <strncmp+0x22>
    80000258:	00054783          	lbu	a5,0(a0)
    8000025c:	cf89                	beqz	a5,80000276 <strncmp+0x26>
    8000025e:	0005c703          	lbu	a4,0(a1)
    80000262:	00f71a63          	bne	a4,a5,80000276 <strncmp+0x26>
    n--, p++, q++;
    80000266:	367d                	addiw	a2,a2,-1
    80000268:	0505                	addi	a0,a0,1
    8000026a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000026c:	f675                	bnez	a2,80000258 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000026e:	4501                	li	a0,0
    80000270:	a809                	j	80000282 <strncmp+0x32>
    80000272:	4501                	li	a0,0
    80000274:	a039                	j	80000282 <strncmp+0x32>
  if(n == 0)
    80000276:	ca09                	beqz	a2,80000288 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000278:	00054503          	lbu	a0,0(a0)
    8000027c:	0005c783          	lbu	a5,0(a1)
    80000280:	9d1d                	subw	a0,a0,a5
}
    80000282:	6422                	ld	s0,8(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    return 0;
    80000288:	4501                	li	a0,0
    8000028a:	bfe5                	j	80000282 <strncmp+0x32>

000000008000028c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000292:	872a                	mv	a4,a0
    80000294:	8832                	mv	a6,a2
    80000296:	367d                	addiw	a2,a2,-1
    80000298:	01005963          	blez	a6,800002aa <strncpy+0x1e>
    8000029c:	0705                	addi	a4,a4,1
    8000029e:	0005c783          	lbu	a5,0(a1)
    800002a2:	fef70fa3          	sb	a5,-1(a4)
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	f7f5                	bnez	a5,80000294 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002aa:	00c05d63          	blez	a2,800002c4 <strncpy+0x38>
    800002ae:	86ba                	mv	a3,a4
    *s++ = 0;
    800002b0:	0685                	addi	a3,a3,1
    800002b2:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b6:	fff6c793          	not	a5,a3
    800002ba:	9fb9                	addw	a5,a5,a4
    800002bc:	010787bb          	addw	a5,a5,a6
    800002c0:	fef048e3          	bgtz	a5,800002b0 <strncpy+0x24>
  return os;
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ca:	1141                	addi	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d0:	02c05363          	blez	a2,800002f6 <safestrcpy+0x2c>
    800002d4:	fff6069b          	addiw	a3,a2,-1
    800002d8:	1682                	slli	a3,a3,0x20
    800002da:	9281                	srli	a3,a3,0x20
    800002dc:	96ae                	add	a3,a3,a1
    800002de:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e0:	00d58963          	beq	a1,a3,800002f2 <safestrcpy+0x28>
    800002e4:	0585                	addi	a1,a1,1
    800002e6:	0785                	addi	a5,a5,1
    800002e8:	fff5c703          	lbu	a4,-1(a1)
    800002ec:	fee78fa3          	sb	a4,-1(a5)
    800002f0:	fb65                	bnez	a4,800002e0 <safestrcpy+0x16>
    ;
  *s = 0;
    800002f2:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f6:	6422                	ld	s0,8(sp)
    800002f8:	0141                	addi	sp,sp,16
    800002fa:	8082                	ret

00000000800002fc <strlen>:

int
strlen(const char *s)
{
    800002fc:	1141                	addi	sp,sp,-16
    800002fe:	e422                	sd	s0,8(sp)
    80000300:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000302:	00054783          	lbu	a5,0(a0)
    80000306:	cf91                	beqz	a5,80000322 <strlen+0x26>
    80000308:	0505                	addi	a0,a0,1
    8000030a:	87aa                	mv	a5,a0
    8000030c:	4685                	li	a3,1
    8000030e:	9e89                	subw	a3,a3,a0
    80000310:	00f6853b          	addw	a0,a3,a5
    80000314:	0785                	addi	a5,a5,1
    80000316:	fff7c703          	lbu	a4,-1(a5)
    8000031a:	fb7d                	bnez	a4,80000310 <strlen+0x14>
    ;
  return n;
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret
  for(n = 0; s[n]; n++)
    80000322:	4501                	li	a0,0
    80000324:	bfe5                	j	8000031c <strlen+0x20>

0000000080000326 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000326:	1141                	addi	sp,sp,-16
    80000328:	e406                	sd	ra,8(sp)
    8000032a:	e022                	sd	s0,0(sp)
    8000032c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000032e:	00001097          	auipc	ra,0x1
    80000332:	afe080e7          	jalr	-1282(ra) # 80000e2c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	00008717          	auipc	a4,0x8
    8000033a:	6da70713          	addi	a4,a4,1754 # 80008a10 <started>
  if(cpuid() == 0){
    8000033e:	c139                	beqz	a0,80000384 <main+0x5e>
    while(started == 0)
    80000340:	431c                	lw	a5,0(a4)
    80000342:	2781                	sext.w	a5,a5
    80000344:	dff5                	beqz	a5,80000340 <main+0x1a>
      ;
    __sync_synchronize();
    80000346:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000034a:	00001097          	auipc	ra,0x1
    8000034e:	ae2080e7          	jalr	-1310(ra) # 80000e2c <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	9b0080e7          	jalr	-1616(ra) # 80005d0c <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00002097          	auipc	ra,0x2
    80000370:	800080e7          	jalr	-2048(ra) # 80001b6c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	dec080e7          	jalr	-532(ra) # 80005160 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	04a080e7          	jalr	74(ra) # 800013c6 <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	850080e7          	jalr	-1968(ra) # 80005bd4 <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	b66080e7          	jalr	-1178(ra) # 80005ef2 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	970080e7          	jalr	-1680(ra) # 80005d0c <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	960080e7          	jalr	-1696(ra) # 80005d0c <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	950080e7          	jalr	-1712(ra) # 80005d0c <printf>
    kinit();         // physical page allocator
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	d18080e7          	jalr	-744(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	326080e7          	jalr	806(ra) # 800006f2 <kvminit>
    kvminithart();   // turn on paging
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	068080e7          	jalr	104(ra) # 8000043c <kvminithart>
    procinit();      // process table
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	99c080e7          	jalr	-1636(ra) # 80000d78 <procinit>
    trapinit();      // trap vectors
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	760080e7          	jalr	1888(ra) # 80001b44 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	780080e7          	jalr	1920(ra) # 80001b6c <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	d56080e7          	jalr	-682(ra) # 8000514a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	d64080e7          	jalr	-668(ra) # 80005160 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	f1c080e7          	jalr	-228(ra) # 80002320 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	5c0080e7          	jalr	1472(ra) # 800029cc <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	55e080e7          	jalr	1374(ra) # 80003972 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	e4c080e7          	jalr	-436(ra) # 80005268 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	d0c080e7          	jalr	-756(ra) # 80001130 <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00008717          	auipc	a4,0x8
    80000436:	5cf72f23          	sw	a5,1502(a4) # 80008a10 <started>
    8000043a:	b789                	j	8000037c <main+0x56>

000000008000043c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e422                	sd	s0,8(sp)
    80000440:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000442:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000446:	00008797          	auipc	a5,0x8
    8000044a:	5d27b783          	ld	a5,1490(a5) # 80008a18 <kernel_pagetable>
    8000044e:	83b1                	srli	a5,a5,0xc
    80000450:	577d                	li	a4,-1
    80000452:	177e                	slli	a4,a4,0x3f
    80000454:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000456:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000045a:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000045e:	6422                	ld	s0,8(sp)
    80000460:	0141                	addi	sp,sp,16
    80000462:	8082                	ret

0000000080000464 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000464:	7139                	addi	sp,sp,-64
    80000466:	fc06                	sd	ra,56(sp)
    80000468:	f822                	sd	s0,48(sp)
    8000046a:	f426                	sd	s1,40(sp)
    8000046c:	f04a                	sd	s2,32(sp)
    8000046e:	ec4e                	sd	s3,24(sp)
    80000470:	e852                	sd	s4,16(sp)
    80000472:	e456                	sd	s5,8(sp)
    80000474:	e05a                	sd	s6,0(sp)
    80000476:	0080                	addi	s0,sp,64
    80000478:	84aa                	mv	s1,a0
    8000047a:	89ae                	mv	s3,a1
    8000047c:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000047e:	57fd                	li	a5,-1
    80000480:	83e9                	srli	a5,a5,0x1a
    80000482:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000484:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000486:	04b7f263          	bgeu	a5,a1,800004ca <walk+0x66>
    panic("walk");
    8000048a:	00008517          	auipc	a0,0x8
    8000048e:	bc650513          	addi	a0,a0,-1082 # 80008050 <etext+0x50>
    80000492:	00006097          	auipc	ra,0x6
    80000496:	830080e7          	jalr	-2000(ra) # 80005cc2 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000049a:	060a8663          	beqz	s5,80000506 <walk+0xa2>
    8000049e:	00000097          	auipc	ra,0x0
    800004a2:	c7a080e7          	jalr	-902(ra) # 80000118 <kalloc>
    800004a6:	84aa                	mv	s1,a0
    800004a8:	c529                	beqz	a0,800004f2 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004aa:	6605                	lui	a2,0x1
    800004ac:	4581                	li	a1,0
    800004ae:	00000097          	auipc	ra,0x0
    800004b2:	cca080e7          	jalr	-822(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b6:	00c4d793          	srli	a5,s1,0xc
    800004ba:	07aa                	slli	a5,a5,0xa
    800004bc:	0017e793          	ori	a5,a5,1
    800004c0:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004c4:	3a5d                	addiw	s4,s4,-9
    800004c6:	036a0063          	beq	s4,s6,800004e6 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004ca:	0149d933          	srl	s2,s3,s4
    800004ce:	1ff97913          	andi	s2,s2,511
    800004d2:	090e                	slli	s2,s2,0x3
    800004d4:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004d6:	00093483          	ld	s1,0(s2)
    800004da:	0014f793          	andi	a5,s1,1
    800004de:	dfd5                	beqz	a5,8000049a <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004e0:	80a9                	srli	s1,s1,0xa
    800004e2:	04b2                	slli	s1,s1,0xc
    800004e4:	b7c5                	j	800004c4 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004e6:	00c9d513          	srli	a0,s3,0xc
    800004ea:	1ff57513          	andi	a0,a0,511
    800004ee:	050e                	slli	a0,a0,0x3
    800004f0:	9526                	add	a0,a0,s1
}
    800004f2:	70e2                	ld	ra,56(sp)
    800004f4:	7442                	ld	s0,48(sp)
    800004f6:	74a2                	ld	s1,40(sp)
    800004f8:	7902                	ld	s2,32(sp)
    800004fa:	69e2                	ld	s3,24(sp)
    800004fc:	6a42                	ld	s4,16(sp)
    800004fe:	6aa2                	ld	s5,8(sp)
    80000500:	6b02                	ld	s6,0(sp)
    80000502:	6121                	addi	sp,sp,64
    80000504:	8082                	ret
        return 0;
    80000506:	4501                	li	a0,0
    80000508:	b7ed                	j	800004f2 <walk+0x8e>

000000008000050a <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000050a:	57fd                	li	a5,-1
    8000050c:	83e9                	srli	a5,a5,0x1a
    8000050e:	00b7f463          	bgeu	a5,a1,80000516 <walkaddr+0xc>
    return 0;
    80000512:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000514:	8082                	ret
{
    80000516:	1141                	addi	sp,sp,-16
    80000518:	e406                	sd	ra,8(sp)
    8000051a:	e022                	sd	s0,0(sp)
    8000051c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000051e:	4601                	li	a2,0
    80000520:	00000097          	auipc	ra,0x0
    80000524:	f44080e7          	jalr	-188(ra) # 80000464 <walk>
  if(pte == 0)
    80000528:	c105                	beqz	a0,80000548 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000052a:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000052c:	0117f693          	andi	a3,a5,17
    80000530:	4745                	li	a4,17
    return 0;
    80000532:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000534:	00e68663          	beq	a3,a4,80000540 <walkaddr+0x36>
}
    80000538:	60a2                	ld	ra,8(sp)
    8000053a:	6402                	ld	s0,0(sp)
    8000053c:	0141                	addi	sp,sp,16
    8000053e:	8082                	ret
  pa = PTE2PA(*pte);
    80000540:	00a7d513          	srli	a0,a5,0xa
    80000544:	0532                	slli	a0,a0,0xc
  return pa;
    80000546:	bfcd                	j	80000538 <walkaddr+0x2e>
    return 0;
    80000548:	4501                	li	a0,0
    8000054a:	b7fd                	j	80000538 <walkaddr+0x2e>

000000008000054c <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000054c:	715d                	addi	sp,sp,-80
    8000054e:	e486                	sd	ra,72(sp)
    80000550:	e0a2                	sd	s0,64(sp)
    80000552:	fc26                	sd	s1,56(sp)
    80000554:	f84a                	sd	s2,48(sp)
    80000556:	f44e                	sd	s3,40(sp)
    80000558:	f052                	sd	s4,32(sp)
    8000055a:	ec56                	sd	s5,24(sp)
    8000055c:	e85a                	sd	s6,16(sp)
    8000055e:	e45e                	sd	s7,8(sp)
    80000560:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000562:	c205                	beqz	a2,80000582 <mappages+0x36>
    80000564:	8aaa                	mv	s5,a0
    80000566:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000568:	77fd                	lui	a5,0xfffff
    8000056a:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    8000056e:	15fd                	addi	a1,a1,-1
    80000570:	00c589b3          	add	s3,a1,a2
    80000574:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000578:	8952                	mv	s2,s4
    8000057a:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000057e:	6b85                	lui	s7,0x1
    80000580:	a015                	j	800005a4 <mappages+0x58>
    panic("mappages: size");
    80000582:	00008517          	auipc	a0,0x8
    80000586:	ad650513          	addi	a0,a0,-1322 # 80008058 <etext+0x58>
    8000058a:	00005097          	auipc	ra,0x5
    8000058e:	738080e7          	jalr	1848(ra) # 80005cc2 <panic>
      panic("mappages: remap");
    80000592:	00008517          	auipc	a0,0x8
    80000596:	ad650513          	addi	a0,a0,-1322 # 80008068 <etext+0x68>
    8000059a:	00005097          	auipc	ra,0x5
    8000059e:	728080e7          	jalr	1832(ra) # 80005cc2 <panic>
    a += PGSIZE;
    800005a2:	995e                	add	s2,s2,s7
  for(;;){
    800005a4:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a8:	4605                	li	a2,1
    800005aa:	85ca                	mv	a1,s2
    800005ac:	8556                	mv	a0,s5
    800005ae:	00000097          	auipc	ra,0x0
    800005b2:	eb6080e7          	jalr	-330(ra) # 80000464 <walk>
    800005b6:	cd19                	beqz	a0,800005d4 <mappages+0x88>
    if(*pte & PTE_V)
    800005b8:	611c                	ld	a5,0(a0)
    800005ba:	8b85                	andi	a5,a5,1
    800005bc:	fbf9                	bnez	a5,80000592 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005be:	80b1                	srli	s1,s1,0xc
    800005c0:	04aa                	slli	s1,s1,0xa
    800005c2:	0164e4b3          	or	s1,s1,s6
    800005c6:	0014e493          	ori	s1,s1,1
    800005ca:	e104                	sd	s1,0(a0)
    if(a == last)
    800005cc:	fd391be3          	bne	s2,s3,800005a2 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800005d0:	4501                	li	a0,0
    800005d2:	a011                	j	800005d6 <mappages+0x8a>
      return -1;
    800005d4:	557d                	li	a0,-1
}
    800005d6:	60a6                	ld	ra,72(sp)
    800005d8:	6406                	ld	s0,64(sp)
    800005da:	74e2                	ld	s1,56(sp)
    800005dc:	7942                	ld	s2,48(sp)
    800005de:	79a2                	ld	s3,40(sp)
    800005e0:	7a02                	ld	s4,32(sp)
    800005e2:	6ae2                	ld	s5,24(sp)
    800005e4:	6b42                	ld	s6,16(sp)
    800005e6:	6ba2                	ld	s7,8(sp)
    800005e8:	6161                	addi	sp,sp,80
    800005ea:	8082                	ret

00000000800005ec <kvmmap>:
{
    800005ec:	1141                	addi	sp,sp,-16
    800005ee:	e406                	sd	ra,8(sp)
    800005f0:	e022                	sd	s0,0(sp)
    800005f2:	0800                	addi	s0,sp,16
    800005f4:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005f6:	86b2                	mv	a3,a2
    800005f8:	863e                	mv	a2,a5
    800005fa:	00000097          	auipc	ra,0x0
    800005fe:	f52080e7          	jalr	-174(ra) # 8000054c <mappages>
    80000602:	e509                	bnez	a0,8000060c <kvmmap+0x20>
}
    80000604:	60a2                	ld	ra,8(sp)
    80000606:	6402                	ld	s0,0(sp)
    80000608:	0141                	addi	sp,sp,16
    8000060a:	8082                	ret
    panic("kvmmap");
    8000060c:	00008517          	auipc	a0,0x8
    80000610:	a6c50513          	addi	a0,a0,-1428 # 80008078 <etext+0x78>
    80000614:	00005097          	auipc	ra,0x5
    80000618:	6ae080e7          	jalr	1710(ra) # 80005cc2 <panic>

000000008000061c <kvmmake>:
{
    8000061c:	1101                	addi	sp,sp,-32
    8000061e:	ec06                	sd	ra,24(sp)
    80000620:	e822                	sd	s0,16(sp)
    80000622:	e426                	sd	s1,8(sp)
    80000624:	e04a                	sd	s2,0(sp)
    80000626:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000628:	00000097          	auipc	ra,0x0
    8000062c:	af0080e7          	jalr	-1296(ra) # 80000118 <kalloc>
    80000630:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000632:	6605                	lui	a2,0x1
    80000634:	4581                	li	a1,0
    80000636:	00000097          	auipc	ra,0x0
    8000063a:	b42080e7          	jalr	-1214(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000063e:	4719                	li	a4,6
    80000640:	6685                	lui	a3,0x1
    80000642:	10000637          	lui	a2,0x10000
    80000646:	100005b7          	lui	a1,0x10000
    8000064a:	8526                	mv	a0,s1
    8000064c:	00000097          	auipc	ra,0x0
    80000650:	fa0080e7          	jalr	-96(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000654:	4719                	li	a4,6
    80000656:	6685                	lui	a3,0x1
    80000658:	10001637          	lui	a2,0x10001
    8000065c:	100015b7          	lui	a1,0x10001
    80000660:	8526                	mv	a0,s1
    80000662:	00000097          	auipc	ra,0x0
    80000666:	f8a080e7          	jalr	-118(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000066a:	4719                	li	a4,6
    8000066c:	004006b7          	lui	a3,0x400
    80000670:	0c000637          	lui	a2,0xc000
    80000674:	0c0005b7          	lui	a1,0xc000
    80000678:	8526                	mv	a0,s1
    8000067a:	00000097          	auipc	ra,0x0
    8000067e:	f72080e7          	jalr	-142(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000682:	00008917          	auipc	s2,0x8
    80000686:	97e90913          	addi	s2,s2,-1666 # 80008000 <etext>
    8000068a:	4729                	li	a4,10
    8000068c:	80008697          	auipc	a3,0x80008
    80000690:	97468693          	addi	a3,a3,-1676 # 8000 <_entry-0x7fff8000>
    80000694:	4605                	li	a2,1
    80000696:	067e                	slli	a2,a2,0x1f
    80000698:	85b2                	mv	a1,a2
    8000069a:	8526                	mv	a0,s1
    8000069c:	00000097          	auipc	ra,0x0
    800006a0:	f50080e7          	jalr	-176(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006a4:	4719                	li	a4,6
    800006a6:	46c5                	li	a3,17
    800006a8:	06ee                	slli	a3,a3,0x1b
    800006aa:	412686b3          	sub	a3,a3,s2
    800006ae:	864a                	mv	a2,s2
    800006b0:	85ca                	mv	a1,s2
    800006b2:	8526                	mv	a0,s1
    800006b4:	00000097          	auipc	ra,0x0
    800006b8:	f38080e7          	jalr	-200(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006bc:	4729                	li	a4,10
    800006be:	6685                	lui	a3,0x1
    800006c0:	00007617          	auipc	a2,0x7
    800006c4:	94060613          	addi	a2,a2,-1728 # 80007000 <_trampoline>
    800006c8:	040005b7          	lui	a1,0x4000
    800006cc:	15fd                	addi	a1,a1,-1
    800006ce:	05b2                	slli	a1,a1,0xc
    800006d0:	8526                	mv	a0,s1
    800006d2:	00000097          	auipc	ra,0x0
    800006d6:	f1a080e7          	jalr	-230(ra) # 800005ec <kvmmap>
  proc_mapstacks(kpgtbl);
    800006da:	8526                	mv	a0,s1
    800006dc:	00000097          	auipc	ra,0x0
    800006e0:	606080e7          	jalr	1542(ra) # 80000ce2 <proc_mapstacks>
}
    800006e4:	8526                	mv	a0,s1
    800006e6:	60e2                	ld	ra,24(sp)
    800006e8:	6442                	ld	s0,16(sp)
    800006ea:	64a2                	ld	s1,8(sp)
    800006ec:	6902                	ld	s2,0(sp)
    800006ee:	6105                	addi	sp,sp,32
    800006f0:	8082                	ret

00000000800006f2 <kvminit>:
{
    800006f2:	1141                	addi	sp,sp,-16
    800006f4:	e406                	sd	ra,8(sp)
    800006f6:	e022                	sd	s0,0(sp)
    800006f8:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006fa:	00000097          	auipc	ra,0x0
    800006fe:	f22080e7          	jalr	-222(ra) # 8000061c <kvmmake>
    80000702:	00008797          	auipc	a5,0x8
    80000706:	30a7bb23          	sd	a0,790(a5) # 80008a18 <kernel_pagetable>
}
    8000070a:	60a2                	ld	ra,8(sp)
    8000070c:	6402                	ld	s0,0(sp)
    8000070e:	0141                	addi	sp,sp,16
    80000710:	8082                	ret

0000000080000712 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000712:	715d                	addi	sp,sp,-80
    80000714:	e486                	sd	ra,72(sp)
    80000716:	e0a2                	sd	s0,64(sp)
    80000718:	fc26                	sd	s1,56(sp)
    8000071a:	f84a                	sd	s2,48(sp)
    8000071c:	f44e                	sd	s3,40(sp)
    8000071e:	f052                	sd	s4,32(sp)
    80000720:	ec56                	sd	s5,24(sp)
    80000722:	e85a                	sd	s6,16(sp)
    80000724:	e45e                	sd	s7,8(sp)
    80000726:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000728:	03459793          	slli	a5,a1,0x34
    8000072c:	e795                	bnez	a5,80000758 <uvmunmap+0x46>
    8000072e:	8a2a                	mv	s4,a0
    80000730:	892e                	mv	s2,a1
    80000732:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000734:	0632                	slli	a2,a2,0xc
    80000736:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000073a:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000073c:	6b05                	lui	s6,0x1
    8000073e:	0735e863          	bltu	a1,s3,800007ae <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000742:	60a6                	ld	ra,72(sp)
    80000744:	6406                	ld	s0,64(sp)
    80000746:	74e2                	ld	s1,56(sp)
    80000748:	7942                	ld	s2,48(sp)
    8000074a:	79a2                	ld	s3,40(sp)
    8000074c:	7a02                	ld	s4,32(sp)
    8000074e:	6ae2                	ld	s5,24(sp)
    80000750:	6b42                	ld	s6,16(sp)
    80000752:	6ba2                	ld	s7,8(sp)
    80000754:	6161                	addi	sp,sp,80
    80000756:	8082                	ret
    panic("uvmunmap: not aligned");
    80000758:	00008517          	auipc	a0,0x8
    8000075c:	92850513          	addi	a0,a0,-1752 # 80008080 <etext+0x80>
    80000760:	00005097          	auipc	ra,0x5
    80000764:	562080e7          	jalr	1378(ra) # 80005cc2 <panic>
      panic("uvmunmap: walk");
    80000768:	00008517          	auipc	a0,0x8
    8000076c:	93050513          	addi	a0,a0,-1744 # 80008098 <etext+0x98>
    80000770:	00005097          	auipc	ra,0x5
    80000774:	552080e7          	jalr	1362(ra) # 80005cc2 <panic>
      panic("uvmunmap: not mapped");
    80000778:	00008517          	auipc	a0,0x8
    8000077c:	93050513          	addi	a0,a0,-1744 # 800080a8 <etext+0xa8>
    80000780:	00005097          	auipc	ra,0x5
    80000784:	542080e7          	jalr	1346(ra) # 80005cc2 <panic>
      panic("uvmunmap: not a leaf");
    80000788:	00008517          	auipc	a0,0x8
    8000078c:	93850513          	addi	a0,a0,-1736 # 800080c0 <etext+0xc0>
    80000790:	00005097          	auipc	ra,0x5
    80000794:	532080e7          	jalr	1330(ra) # 80005cc2 <panic>
      uint64 pa = PTE2PA(*pte);
    80000798:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000079a:	0532                	slli	a0,a0,0xc
    8000079c:	00000097          	auipc	ra,0x0
    800007a0:	880080e7          	jalr	-1920(ra) # 8000001c <kfree>
    *pte = 0;
    800007a4:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007a8:	995a                	add	s2,s2,s6
    800007aa:	f9397ce3          	bgeu	s2,s3,80000742 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007ae:	4601                	li	a2,0
    800007b0:	85ca                	mv	a1,s2
    800007b2:	8552                	mv	a0,s4
    800007b4:	00000097          	auipc	ra,0x0
    800007b8:	cb0080e7          	jalr	-848(ra) # 80000464 <walk>
    800007bc:	84aa                	mv	s1,a0
    800007be:	d54d                	beqz	a0,80000768 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007c0:	6108                	ld	a0,0(a0)
    800007c2:	00157793          	andi	a5,a0,1
    800007c6:	dbcd                	beqz	a5,80000778 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007c8:	3ff57793          	andi	a5,a0,1023
    800007cc:	fb778ee3          	beq	a5,s7,80000788 <uvmunmap+0x76>
    if(do_free){
    800007d0:	fc0a8ae3          	beqz	s5,800007a4 <uvmunmap+0x92>
    800007d4:	b7d1                	j	80000798 <uvmunmap+0x86>

00000000800007d6 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007d6:	1101                	addi	sp,sp,-32
    800007d8:	ec06                	sd	ra,24(sp)
    800007da:	e822                	sd	s0,16(sp)
    800007dc:	e426                	sd	s1,8(sp)
    800007de:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007e0:	00000097          	auipc	ra,0x0
    800007e4:	938080e7          	jalr	-1736(ra) # 80000118 <kalloc>
    800007e8:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007ea:	c519                	beqz	a0,800007f8 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007ec:	6605                	lui	a2,0x1
    800007ee:	4581                	li	a1,0
    800007f0:	00000097          	auipc	ra,0x0
    800007f4:	988080e7          	jalr	-1656(ra) # 80000178 <memset>
  return pagetable;
}
    800007f8:	8526                	mv	a0,s1
    800007fa:	60e2                	ld	ra,24(sp)
    800007fc:	6442                	ld	s0,16(sp)
    800007fe:	64a2                	ld	s1,8(sp)
    80000800:	6105                	addi	sp,sp,32
    80000802:	8082                	ret

0000000080000804 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000804:	7179                	addi	sp,sp,-48
    80000806:	f406                	sd	ra,40(sp)
    80000808:	f022                	sd	s0,32(sp)
    8000080a:	ec26                	sd	s1,24(sp)
    8000080c:	e84a                	sd	s2,16(sp)
    8000080e:	e44e                	sd	s3,8(sp)
    80000810:	e052                	sd	s4,0(sp)
    80000812:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000814:	6785                	lui	a5,0x1
    80000816:	04f67863          	bgeu	a2,a5,80000866 <uvmfirst+0x62>
    8000081a:	8a2a                	mv	s4,a0
    8000081c:	89ae                	mv	s3,a1
    8000081e:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000820:	00000097          	auipc	ra,0x0
    80000824:	8f8080e7          	jalr	-1800(ra) # 80000118 <kalloc>
    80000828:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000082a:	6605                	lui	a2,0x1
    8000082c:	4581                	li	a1,0
    8000082e:	00000097          	auipc	ra,0x0
    80000832:	94a080e7          	jalr	-1718(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000836:	4779                	li	a4,30
    80000838:	86ca                	mv	a3,s2
    8000083a:	6605                	lui	a2,0x1
    8000083c:	4581                	li	a1,0
    8000083e:	8552                	mv	a0,s4
    80000840:	00000097          	auipc	ra,0x0
    80000844:	d0c080e7          	jalr	-756(ra) # 8000054c <mappages>
  memmove(mem, src, sz);
    80000848:	8626                	mv	a2,s1
    8000084a:	85ce                	mv	a1,s3
    8000084c:	854a                	mv	a0,s2
    8000084e:	00000097          	auipc	ra,0x0
    80000852:	98a080e7          	jalr	-1654(ra) # 800001d8 <memmove>
}
    80000856:	70a2                	ld	ra,40(sp)
    80000858:	7402                	ld	s0,32(sp)
    8000085a:	64e2                	ld	s1,24(sp)
    8000085c:	6942                	ld	s2,16(sp)
    8000085e:	69a2                	ld	s3,8(sp)
    80000860:	6a02                	ld	s4,0(sp)
    80000862:	6145                	addi	sp,sp,48
    80000864:	8082                	ret
    panic("uvmfirst: more than a page");
    80000866:	00008517          	auipc	a0,0x8
    8000086a:	87250513          	addi	a0,a0,-1934 # 800080d8 <etext+0xd8>
    8000086e:	00005097          	auipc	ra,0x5
    80000872:	454080e7          	jalr	1108(ra) # 80005cc2 <panic>

0000000080000876 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000876:	1101                	addi	sp,sp,-32
    80000878:	ec06                	sd	ra,24(sp)
    8000087a:	e822                	sd	s0,16(sp)
    8000087c:	e426                	sd	s1,8(sp)
    8000087e:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000880:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000882:	00b67d63          	bgeu	a2,a1,8000089c <uvmdealloc+0x26>
    80000886:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000888:	6785                	lui	a5,0x1
    8000088a:	17fd                	addi	a5,a5,-1
    8000088c:	00f60733          	add	a4,a2,a5
    80000890:	767d                	lui	a2,0xfffff
    80000892:	8f71                	and	a4,a4,a2
    80000894:	97ae                	add	a5,a5,a1
    80000896:	8ff1                	and	a5,a5,a2
    80000898:	00f76863          	bltu	a4,a5,800008a8 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000089c:	8526                	mv	a0,s1
    8000089e:	60e2                	ld	ra,24(sp)
    800008a0:	6442                	ld	s0,16(sp)
    800008a2:	64a2                	ld	s1,8(sp)
    800008a4:	6105                	addi	sp,sp,32
    800008a6:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a8:	8f99                	sub	a5,a5,a4
    800008aa:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008ac:	4685                	li	a3,1
    800008ae:	0007861b          	sext.w	a2,a5
    800008b2:	85ba                	mv	a1,a4
    800008b4:	00000097          	auipc	ra,0x0
    800008b8:	e5e080e7          	jalr	-418(ra) # 80000712 <uvmunmap>
    800008bc:	b7c5                	j	8000089c <uvmdealloc+0x26>

00000000800008be <uvmalloc>:
  if(newsz < oldsz)
    800008be:	0ab66563          	bltu	a2,a1,80000968 <uvmalloc+0xaa>
{
    800008c2:	7139                	addi	sp,sp,-64
    800008c4:	fc06                	sd	ra,56(sp)
    800008c6:	f822                	sd	s0,48(sp)
    800008c8:	f426                	sd	s1,40(sp)
    800008ca:	f04a                	sd	s2,32(sp)
    800008cc:	ec4e                	sd	s3,24(sp)
    800008ce:	e852                	sd	s4,16(sp)
    800008d0:	e456                	sd	s5,8(sp)
    800008d2:	e05a                	sd	s6,0(sp)
    800008d4:	0080                	addi	s0,sp,64
    800008d6:	8aaa                	mv	s5,a0
    800008d8:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008da:	6985                	lui	s3,0x1
    800008dc:	19fd                	addi	s3,s3,-1
    800008de:	95ce                	add	a1,a1,s3
    800008e0:	79fd                	lui	s3,0xfffff
    800008e2:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008e6:	08c9f363          	bgeu	s3,a2,8000096c <uvmalloc+0xae>
    800008ea:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800008ec:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800008f0:	00000097          	auipc	ra,0x0
    800008f4:	828080e7          	jalr	-2008(ra) # 80000118 <kalloc>
    800008f8:	84aa                	mv	s1,a0
    if(mem == 0){
    800008fa:	c51d                	beqz	a0,80000928 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800008fc:	6605                	lui	a2,0x1
    800008fe:	4581                	li	a1,0
    80000900:	00000097          	auipc	ra,0x0
    80000904:	878080e7          	jalr	-1928(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000908:	875a                	mv	a4,s6
    8000090a:	86a6                	mv	a3,s1
    8000090c:	6605                	lui	a2,0x1
    8000090e:	85ca                	mv	a1,s2
    80000910:	8556                	mv	a0,s5
    80000912:	00000097          	auipc	ra,0x0
    80000916:	c3a080e7          	jalr	-966(ra) # 8000054c <mappages>
    8000091a:	e90d                	bnez	a0,8000094c <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000091c:	6785                	lui	a5,0x1
    8000091e:	993e                	add	s2,s2,a5
    80000920:	fd4968e3          	bltu	s2,s4,800008f0 <uvmalloc+0x32>
  return newsz;
    80000924:	8552                	mv	a0,s4
    80000926:	a809                	j	80000938 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000928:	864e                	mv	a2,s3
    8000092a:	85ca                	mv	a1,s2
    8000092c:	8556                	mv	a0,s5
    8000092e:	00000097          	auipc	ra,0x0
    80000932:	f48080e7          	jalr	-184(ra) # 80000876 <uvmdealloc>
      return 0;
    80000936:	4501                	li	a0,0
}
    80000938:	70e2                	ld	ra,56(sp)
    8000093a:	7442                	ld	s0,48(sp)
    8000093c:	74a2                	ld	s1,40(sp)
    8000093e:	7902                	ld	s2,32(sp)
    80000940:	69e2                	ld	s3,24(sp)
    80000942:	6a42                	ld	s4,16(sp)
    80000944:	6aa2                	ld	s5,8(sp)
    80000946:	6b02                	ld	s6,0(sp)
    80000948:	6121                	addi	sp,sp,64
    8000094a:	8082                	ret
      kfree(mem);
    8000094c:	8526                	mv	a0,s1
    8000094e:	fffff097          	auipc	ra,0xfffff
    80000952:	6ce080e7          	jalr	1742(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000956:	864e                	mv	a2,s3
    80000958:	85ca                	mv	a1,s2
    8000095a:	8556                	mv	a0,s5
    8000095c:	00000097          	auipc	ra,0x0
    80000960:	f1a080e7          	jalr	-230(ra) # 80000876 <uvmdealloc>
      return 0;
    80000964:	4501                	li	a0,0
    80000966:	bfc9                	j	80000938 <uvmalloc+0x7a>
    return oldsz;
    80000968:	852e                	mv	a0,a1
}
    8000096a:	8082                	ret
  return newsz;
    8000096c:	8532                	mv	a0,a2
    8000096e:	b7e9                	j	80000938 <uvmalloc+0x7a>

0000000080000970 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000970:	7179                	addi	sp,sp,-48
    80000972:	f406                	sd	ra,40(sp)
    80000974:	f022                	sd	s0,32(sp)
    80000976:	ec26                	sd	s1,24(sp)
    80000978:	e84a                	sd	s2,16(sp)
    8000097a:	e44e                	sd	s3,8(sp)
    8000097c:	e052                	sd	s4,0(sp)
    8000097e:	1800                	addi	s0,sp,48
    80000980:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000982:	84aa                	mv	s1,a0
    80000984:	6905                	lui	s2,0x1
    80000986:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000988:	4985                	li	s3,1
    8000098a:	a821                	j	800009a2 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000098c:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    8000098e:	0532                	slli	a0,a0,0xc
    80000990:	00000097          	auipc	ra,0x0
    80000994:	fe0080e7          	jalr	-32(ra) # 80000970 <freewalk>
      pagetable[i] = 0;
    80000998:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000099c:	04a1                	addi	s1,s1,8
    8000099e:	03248163          	beq	s1,s2,800009c0 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009a2:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009a4:	00f57793          	andi	a5,a0,15
    800009a8:	ff3782e3          	beq	a5,s3,8000098c <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009ac:	8905                	andi	a0,a0,1
    800009ae:	d57d                	beqz	a0,8000099c <freewalk+0x2c>
      panic("freewalk: leaf");
    800009b0:	00007517          	auipc	a0,0x7
    800009b4:	74850513          	addi	a0,a0,1864 # 800080f8 <etext+0xf8>
    800009b8:	00005097          	auipc	ra,0x5
    800009bc:	30a080e7          	jalr	778(ra) # 80005cc2 <panic>
    }
  }
  kfree((void*)pagetable);
    800009c0:	8552                	mv	a0,s4
    800009c2:	fffff097          	auipc	ra,0xfffff
    800009c6:	65a080e7          	jalr	1626(ra) # 8000001c <kfree>
}
    800009ca:	70a2                	ld	ra,40(sp)
    800009cc:	7402                	ld	s0,32(sp)
    800009ce:	64e2                	ld	s1,24(sp)
    800009d0:	6942                	ld	s2,16(sp)
    800009d2:	69a2                	ld	s3,8(sp)
    800009d4:	6a02                	ld	s4,0(sp)
    800009d6:	6145                	addi	sp,sp,48
    800009d8:	8082                	ret

00000000800009da <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009da:	1101                	addi	sp,sp,-32
    800009dc:	ec06                	sd	ra,24(sp)
    800009de:	e822                	sd	s0,16(sp)
    800009e0:	e426                	sd	s1,8(sp)
    800009e2:	1000                	addi	s0,sp,32
    800009e4:	84aa                	mv	s1,a0
  if(sz > 0)
    800009e6:	e999                	bnez	a1,800009fc <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009e8:	8526                	mv	a0,s1
    800009ea:	00000097          	auipc	ra,0x0
    800009ee:	f86080e7          	jalr	-122(ra) # 80000970 <freewalk>
}
    800009f2:	60e2                	ld	ra,24(sp)
    800009f4:	6442                	ld	s0,16(sp)
    800009f6:	64a2                	ld	s1,8(sp)
    800009f8:	6105                	addi	sp,sp,32
    800009fa:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009fc:	6605                	lui	a2,0x1
    800009fe:	167d                	addi	a2,a2,-1
    80000a00:	962e                	add	a2,a2,a1
    80000a02:	4685                	li	a3,1
    80000a04:	8231                	srli	a2,a2,0xc
    80000a06:	4581                	li	a1,0
    80000a08:	00000097          	auipc	ra,0x0
    80000a0c:	d0a080e7          	jalr	-758(ra) # 80000712 <uvmunmap>
    80000a10:	bfe1                	j	800009e8 <uvmfree+0xe>

0000000080000a12 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a12:	c679                	beqz	a2,80000ae0 <uvmcopy+0xce>
{
    80000a14:	715d                	addi	sp,sp,-80
    80000a16:	e486                	sd	ra,72(sp)
    80000a18:	e0a2                	sd	s0,64(sp)
    80000a1a:	fc26                	sd	s1,56(sp)
    80000a1c:	f84a                	sd	s2,48(sp)
    80000a1e:	f44e                	sd	s3,40(sp)
    80000a20:	f052                	sd	s4,32(sp)
    80000a22:	ec56                	sd	s5,24(sp)
    80000a24:	e85a                	sd	s6,16(sp)
    80000a26:	e45e                	sd	s7,8(sp)
    80000a28:	0880                	addi	s0,sp,80
    80000a2a:	8b2a                	mv	s6,a0
    80000a2c:	8aae                	mv	s5,a1
    80000a2e:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a30:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a32:	4601                	li	a2,0
    80000a34:	85ce                	mv	a1,s3
    80000a36:	855a                	mv	a0,s6
    80000a38:	00000097          	auipc	ra,0x0
    80000a3c:	a2c080e7          	jalr	-1492(ra) # 80000464 <walk>
    80000a40:	c531                	beqz	a0,80000a8c <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a42:	6118                	ld	a4,0(a0)
    80000a44:	00177793          	andi	a5,a4,1
    80000a48:	cbb1                	beqz	a5,80000a9c <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a4a:	00a75593          	srli	a1,a4,0xa
    80000a4e:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a52:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a56:	fffff097          	auipc	ra,0xfffff
    80000a5a:	6c2080e7          	jalr	1730(ra) # 80000118 <kalloc>
    80000a5e:	892a                	mv	s2,a0
    80000a60:	c939                	beqz	a0,80000ab6 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a62:	6605                	lui	a2,0x1
    80000a64:	85de                	mv	a1,s7
    80000a66:	fffff097          	auipc	ra,0xfffff
    80000a6a:	772080e7          	jalr	1906(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a6e:	8726                	mv	a4,s1
    80000a70:	86ca                	mv	a3,s2
    80000a72:	6605                	lui	a2,0x1
    80000a74:	85ce                	mv	a1,s3
    80000a76:	8556                	mv	a0,s5
    80000a78:	00000097          	auipc	ra,0x0
    80000a7c:	ad4080e7          	jalr	-1324(ra) # 8000054c <mappages>
    80000a80:	e515                	bnez	a0,80000aac <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a82:	6785                	lui	a5,0x1
    80000a84:	99be                	add	s3,s3,a5
    80000a86:	fb49e6e3          	bltu	s3,s4,80000a32 <uvmcopy+0x20>
    80000a8a:	a081                	j	80000aca <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a8c:	00007517          	auipc	a0,0x7
    80000a90:	67c50513          	addi	a0,a0,1660 # 80008108 <etext+0x108>
    80000a94:	00005097          	auipc	ra,0x5
    80000a98:	22e080e7          	jalr	558(ra) # 80005cc2 <panic>
      panic("uvmcopy: page not present");
    80000a9c:	00007517          	auipc	a0,0x7
    80000aa0:	68c50513          	addi	a0,a0,1676 # 80008128 <etext+0x128>
    80000aa4:	00005097          	auipc	ra,0x5
    80000aa8:	21e080e7          	jalr	542(ra) # 80005cc2 <panic>
      kfree(mem);
    80000aac:	854a                	mv	a0,s2
    80000aae:	fffff097          	auipc	ra,0xfffff
    80000ab2:	56e080e7          	jalr	1390(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ab6:	4685                	li	a3,1
    80000ab8:	00c9d613          	srli	a2,s3,0xc
    80000abc:	4581                	li	a1,0
    80000abe:	8556                	mv	a0,s5
    80000ac0:	00000097          	auipc	ra,0x0
    80000ac4:	c52080e7          	jalr	-942(ra) # 80000712 <uvmunmap>
  return -1;
    80000ac8:	557d                	li	a0,-1
}
    80000aca:	60a6                	ld	ra,72(sp)
    80000acc:	6406                	ld	s0,64(sp)
    80000ace:	74e2                	ld	s1,56(sp)
    80000ad0:	7942                	ld	s2,48(sp)
    80000ad2:	79a2                	ld	s3,40(sp)
    80000ad4:	7a02                	ld	s4,32(sp)
    80000ad6:	6ae2                	ld	s5,24(sp)
    80000ad8:	6b42                	ld	s6,16(sp)
    80000ada:	6ba2                	ld	s7,8(sp)
    80000adc:	6161                	addi	sp,sp,80
    80000ade:	8082                	ret
  return 0;
    80000ae0:	4501                	li	a0,0
}
    80000ae2:	8082                	ret

0000000080000ae4 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ae4:	1141                	addi	sp,sp,-16
    80000ae6:	e406                	sd	ra,8(sp)
    80000ae8:	e022                	sd	s0,0(sp)
    80000aea:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000aec:	4601                	li	a2,0
    80000aee:	00000097          	auipc	ra,0x0
    80000af2:	976080e7          	jalr	-1674(ra) # 80000464 <walk>
  if(pte == 0)
    80000af6:	c901                	beqz	a0,80000b06 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000af8:	611c                	ld	a5,0(a0)
    80000afa:	9bbd                	andi	a5,a5,-17
    80000afc:	e11c                	sd	a5,0(a0)
}
    80000afe:	60a2                	ld	ra,8(sp)
    80000b00:	6402                	ld	s0,0(sp)
    80000b02:	0141                	addi	sp,sp,16
    80000b04:	8082                	ret
    panic("uvmclear");
    80000b06:	00007517          	auipc	a0,0x7
    80000b0a:	64250513          	addi	a0,a0,1602 # 80008148 <etext+0x148>
    80000b0e:	00005097          	auipc	ra,0x5
    80000b12:	1b4080e7          	jalr	436(ra) # 80005cc2 <panic>

0000000080000b16 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b16:	c6bd                	beqz	a3,80000b84 <copyout+0x6e>
{
    80000b18:	715d                	addi	sp,sp,-80
    80000b1a:	e486                	sd	ra,72(sp)
    80000b1c:	e0a2                	sd	s0,64(sp)
    80000b1e:	fc26                	sd	s1,56(sp)
    80000b20:	f84a                	sd	s2,48(sp)
    80000b22:	f44e                	sd	s3,40(sp)
    80000b24:	f052                	sd	s4,32(sp)
    80000b26:	ec56                	sd	s5,24(sp)
    80000b28:	e85a                	sd	s6,16(sp)
    80000b2a:	e45e                	sd	s7,8(sp)
    80000b2c:	e062                	sd	s8,0(sp)
    80000b2e:	0880                	addi	s0,sp,80
    80000b30:	8b2a                	mv	s6,a0
    80000b32:	8c2e                	mv	s8,a1
    80000b34:	8a32                	mv	s4,a2
    80000b36:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b38:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b3a:	6a85                	lui	s5,0x1
    80000b3c:	a015                	j	80000b60 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b3e:	9562                	add	a0,a0,s8
    80000b40:	0004861b          	sext.w	a2,s1
    80000b44:	85d2                	mv	a1,s4
    80000b46:	41250533          	sub	a0,a0,s2
    80000b4a:	fffff097          	auipc	ra,0xfffff
    80000b4e:	68e080e7          	jalr	1678(ra) # 800001d8 <memmove>

    len -= n;
    80000b52:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b56:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b58:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b5c:	02098263          	beqz	s3,80000b80 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b60:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b64:	85ca                	mv	a1,s2
    80000b66:	855a                	mv	a0,s6
    80000b68:	00000097          	auipc	ra,0x0
    80000b6c:	9a2080e7          	jalr	-1630(ra) # 8000050a <walkaddr>
    if(pa0 == 0)
    80000b70:	cd01                	beqz	a0,80000b88 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b72:	418904b3          	sub	s1,s2,s8
    80000b76:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b78:	fc99f3e3          	bgeu	s3,s1,80000b3e <copyout+0x28>
    80000b7c:	84ce                	mv	s1,s3
    80000b7e:	b7c1                	j	80000b3e <copyout+0x28>
  }
  return 0;
    80000b80:	4501                	li	a0,0
    80000b82:	a021                	j	80000b8a <copyout+0x74>
    80000b84:	4501                	li	a0,0
}
    80000b86:	8082                	ret
      return -1;
    80000b88:	557d                	li	a0,-1
}
    80000b8a:	60a6                	ld	ra,72(sp)
    80000b8c:	6406                	ld	s0,64(sp)
    80000b8e:	74e2                	ld	s1,56(sp)
    80000b90:	7942                	ld	s2,48(sp)
    80000b92:	79a2                	ld	s3,40(sp)
    80000b94:	7a02                	ld	s4,32(sp)
    80000b96:	6ae2                	ld	s5,24(sp)
    80000b98:	6b42                	ld	s6,16(sp)
    80000b9a:	6ba2                	ld	s7,8(sp)
    80000b9c:	6c02                	ld	s8,0(sp)
    80000b9e:	6161                	addi	sp,sp,80
    80000ba0:	8082                	ret

0000000080000ba2 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000ba2:	c6bd                	beqz	a3,80000c10 <copyin+0x6e>
{
    80000ba4:	715d                	addi	sp,sp,-80
    80000ba6:	e486                	sd	ra,72(sp)
    80000ba8:	e0a2                	sd	s0,64(sp)
    80000baa:	fc26                	sd	s1,56(sp)
    80000bac:	f84a                	sd	s2,48(sp)
    80000bae:	f44e                	sd	s3,40(sp)
    80000bb0:	f052                	sd	s4,32(sp)
    80000bb2:	ec56                	sd	s5,24(sp)
    80000bb4:	e85a                	sd	s6,16(sp)
    80000bb6:	e45e                	sd	s7,8(sp)
    80000bb8:	e062                	sd	s8,0(sp)
    80000bba:	0880                	addi	s0,sp,80
    80000bbc:	8b2a                	mv	s6,a0
    80000bbe:	8a2e                	mv	s4,a1
    80000bc0:	8c32                	mv	s8,a2
    80000bc2:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bc4:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bc6:	6a85                	lui	s5,0x1
    80000bc8:	a015                	j	80000bec <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bca:	9562                	add	a0,a0,s8
    80000bcc:	0004861b          	sext.w	a2,s1
    80000bd0:	412505b3          	sub	a1,a0,s2
    80000bd4:	8552                	mv	a0,s4
    80000bd6:	fffff097          	auipc	ra,0xfffff
    80000bda:	602080e7          	jalr	1538(ra) # 800001d8 <memmove>

    len -= n;
    80000bde:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000be2:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000be4:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000be8:	02098263          	beqz	s3,80000c0c <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000bec:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bf0:	85ca                	mv	a1,s2
    80000bf2:	855a                	mv	a0,s6
    80000bf4:	00000097          	auipc	ra,0x0
    80000bf8:	916080e7          	jalr	-1770(ra) # 8000050a <walkaddr>
    if(pa0 == 0)
    80000bfc:	cd01                	beqz	a0,80000c14 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000bfe:	418904b3          	sub	s1,s2,s8
    80000c02:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c04:	fc99f3e3          	bgeu	s3,s1,80000bca <copyin+0x28>
    80000c08:	84ce                	mv	s1,s3
    80000c0a:	b7c1                	j	80000bca <copyin+0x28>
  }
  return 0;
    80000c0c:	4501                	li	a0,0
    80000c0e:	a021                	j	80000c16 <copyin+0x74>
    80000c10:	4501                	li	a0,0
}
    80000c12:	8082                	ret
      return -1;
    80000c14:	557d                	li	a0,-1
}
    80000c16:	60a6                	ld	ra,72(sp)
    80000c18:	6406                	ld	s0,64(sp)
    80000c1a:	74e2                	ld	s1,56(sp)
    80000c1c:	7942                	ld	s2,48(sp)
    80000c1e:	79a2                	ld	s3,40(sp)
    80000c20:	7a02                	ld	s4,32(sp)
    80000c22:	6ae2                	ld	s5,24(sp)
    80000c24:	6b42                	ld	s6,16(sp)
    80000c26:	6ba2                	ld	s7,8(sp)
    80000c28:	6c02                	ld	s8,0(sp)
    80000c2a:	6161                	addi	sp,sp,80
    80000c2c:	8082                	ret

0000000080000c2e <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c2e:	c6c5                	beqz	a3,80000cd6 <copyinstr+0xa8>
{
    80000c30:	715d                	addi	sp,sp,-80
    80000c32:	e486                	sd	ra,72(sp)
    80000c34:	e0a2                	sd	s0,64(sp)
    80000c36:	fc26                	sd	s1,56(sp)
    80000c38:	f84a                	sd	s2,48(sp)
    80000c3a:	f44e                	sd	s3,40(sp)
    80000c3c:	f052                	sd	s4,32(sp)
    80000c3e:	ec56                	sd	s5,24(sp)
    80000c40:	e85a                	sd	s6,16(sp)
    80000c42:	e45e                	sd	s7,8(sp)
    80000c44:	0880                	addi	s0,sp,80
    80000c46:	8a2a                	mv	s4,a0
    80000c48:	8b2e                	mv	s6,a1
    80000c4a:	8bb2                	mv	s7,a2
    80000c4c:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c4e:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c50:	6985                	lui	s3,0x1
    80000c52:	a035                	j	80000c7e <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c54:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c58:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c5a:	0017b793          	seqz	a5,a5
    80000c5e:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c62:	60a6                	ld	ra,72(sp)
    80000c64:	6406                	ld	s0,64(sp)
    80000c66:	74e2                	ld	s1,56(sp)
    80000c68:	7942                	ld	s2,48(sp)
    80000c6a:	79a2                	ld	s3,40(sp)
    80000c6c:	7a02                	ld	s4,32(sp)
    80000c6e:	6ae2                	ld	s5,24(sp)
    80000c70:	6b42                	ld	s6,16(sp)
    80000c72:	6ba2                	ld	s7,8(sp)
    80000c74:	6161                	addi	sp,sp,80
    80000c76:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c78:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c7c:	c8a9                	beqz	s1,80000cce <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c7e:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c82:	85ca                	mv	a1,s2
    80000c84:	8552                	mv	a0,s4
    80000c86:	00000097          	auipc	ra,0x0
    80000c8a:	884080e7          	jalr	-1916(ra) # 8000050a <walkaddr>
    if(pa0 == 0)
    80000c8e:	c131                	beqz	a0,80000cd2 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c90:	41790833          	sub	a6,s2,s7
    80000c94:	984e                	add	a6,a6,s3
    if(n > max)
    80000c96:	0104f363          	bgeu	s1,a6,80000c9c <copyinstr+0x6e>
    80000c9a:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c9c:	955e                	add	a0,a0,s7
    80000c9e:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000ca2:	fc080be3          	beqz	a6,80000c78 <copyinstr+0x4a>
    80000ca6:	985a                	add	a6,a6,s6
    80000ca8:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000caa:	41650633          	sub	a2,a0,s6
    80000cae:	14fd                	addi	s1,s1,-1
    80000cb0:	9b26                	add	s6,s6,s1
    80000cb2:	00f60733          	add	a4,a2,a5
    80000cb6:	00074703          	lbu	a4,0(a4)
    80000cba:	df49                	beqz	a4,80000c54 <copyinstr+0x26>
        *dst = *p;
    80000cbc:	00e78023          	sb	a4,0(a5)
      --max;
    80000cc0:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000cc4:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cc6:	ff0796e3          	bne	a5,a6,80000cb2 <copyinstr+0x84>
      dst++;
    80000cca:	8b42                	mv	s6,a6
    80000ccc:	b775                	j	80000c78 <copyinstr+0x4a>
    80000cce:	4781                	li	a5,0
    80000cd0:	b769                	j	80000c5a <copyinstr+0x2c>
      return -1;
    80000cd2:	557d                	li	a0,-1
    80000cd4:	b779                	j	80000c62 <copyinstr+0x34>
  int got_null = 0;
    80000cd6:	4781                	li	a5,0
  if(got_null){
    80000cd8:	0017b793          	seqz	a5,a5
    80000cdc:	40f00533          	neg	a0,a5
}
    80000ce0:	8082                	ret

0000000080000ce2 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000ce2:	7139                	addi	sp,sp,-64
    80000ce4:	fc06                	sd	ra,56(sp)
    80000ce6:	f822                	sd	s0,48(sp)
    80000ce8:	f426                	sd	s1,40(sp)
    80000cea:	f04a                	sd	s2,32(sp)
    80000cec:	ec4e                	sd	s3,24(sp)
    80000cee:	e852                	sd	s4,16(sp)
    80000cf0:	e456                	sd	s5,8(sp)
    80000cf2:	e05a                	sd	s6,0(sp)
    80000cf4:	0080                	addi	s0,sp,64
    80000cf6:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cf8:	00008497          	auipc	s1,0x8
    80000cfc:	19848493          	addi	s1,s1,408 # 80008e90 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d00:	8b26                	mv	s6,s1
    80000d02:	00007a97          	auipc	s5,0x7
    80000d06:	2fea8a93          	addi	s5,s5,766 # 80008000 <etext>
    80000d0a:	04000937          	lui	s2,0x4000
    80000d0e:	197d                	addi	s2,s2,-1
    80000d10:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d12:	0000ea17          	auipc	s4,0xe
    80000d16:	b7ea0a13          	addi	s4,s4,-1154 # 8000e890 <tickslock>
    char *pa = kalloc();
    80000d1a:	fffff097          	auipc	ra,0xfffff
    80000d1e:	3fe080e7          	jalr	1022(ra) # 80000118 <kalloc>
    80000d22:	862a                	mv	a2,a0
    if(pa == 0)
    80000d24:	c131                	beqz	a0,80000d68 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d26:	416485b3          	sub	a1,s1,s6
    80000d2a:	858d                	srai	a1,a1,0x3
    80000d2c:	000ab783          	ld	a5,0(s5)
    80000d30:	02f585b3          	mul	a1,a1,a5
    80000d34:	2585                	addiw	a1,a1,1
    80000d36:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d3a:	4719                	li	a4,6
    80000d3c:	6685                	lui	a3,0x1
    80000d3e:	40b905b3          	sub	a1,s2,a1
    80000d42:	854e                	mv	a0,s3
    80000d44:	00000097          	auipc	ra,0x0
    80000d48:	8a8080e7          	jalr	-1880(ra) # 800005ec <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d4c:	16848493          	addi	s1,s1,360
    80000d50:	fd4495e3          	bne	s1,s4,80000d1a <proc_mapstacks+0x38>
  }
}
    80000d54:	70e2                	ld	ra,56(sp)
    80000d56:	7442                	ld	s0,48(sp)
    80000d58:	74a2                	ld	s1,40(sp)
    80000d5a:	7902                	ld	s2,32(sp)
    80000d5c:	69e2                	ld	s3,24(sp)
    80000d5e:	6a42                	ld	s4,16(sp)
    80000d60:	6aa2                	ld	s5,8(sp)
    80000d62:	6b02                	ld	s6,0(sp)
    80000d64:	6121                	addi	sp,sp,64
    80000d66:	8082                	ret
      panic("kalloc");
    80000d68:	00007517          	auipc	a0,0x7
    80000d6c:	3f050513          	addi	a0,a0,1008 # 80008158 <etext+0x158>
    80000d70:	00005097          	auipc	ra,0x5
    80000d74:	f52080e7          	jalr	-174(ra) # 80005cc2 <panic>

0000000080000d78 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000d78:	7139                	addi	sp,sp,-64
    80000d7a:	fc06                	sd	ra,56(sp)
    80000d7c:	f822                	sd	s0,48(sp)
    80000d7e:	f426                	sd	s1,40(sp)
    80000d80:	f04a                	sd	s2,32(sp)
    80000d82:	ec4e                	sd	s3,24(sp)
    80000d84:	e852                	sd	s4,16(sp)
    80000d86:	e456                	sd	s5,8(sp)
    80000d88:	e05a                	sd	s6,0(sp)
    80000d8a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d8c:	00007597          	auipc	a1,0x7
    80000d90:	3d458593          	addi	a1,a1,980 # 80008160 <etext+0x160>
    80000d94:	00008517          	auipc	a0,0x8
    80000d98:	ccc50513          	addi	a0,a0,-820 # 80008a60 <pid_lock>
    80000d9c:	00005097          	auipc	ra,0x5
    80000da0:	3e0080e7          	jalr	992(ra) # 8000617c <initlock>
  initlock(&wait_lock, "wait_lock");
    80000da4:	00007597          	auipc	a1,0x7
    80000da8:	3c458593          	addi	a1,a1,964 # 80008168 <etext+0x168>
    80000dac:	00008517          	auipc	a0,0x8
    80000db0:	ccc50513          	addi	a0,a0,-820 # 80008a78 <wait_lock>
    80000db4:	00005097          	auipc	ra,0x5
    80000db8:	3c8080e7          	jalr	968(ra) # 8000617c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dbc:	00008497          	auipc	s1,0x8
    80000dc0:	0d448493          	addi	s1,s1,212 # 80008e90 <proc>
      initlock(&p->lock, "proc");
    80000dc4:	00007b17          	auipc	s6,0x7
    80000dc8:	3b4b0b13          	addi	s6,s6,948 # 80008178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000dcc:	8aa6                	mv	s5,s1
    80000dce:	00007a17          	auipc	s4,0x7
    80000dd2:	232a0a13          	addi	s4,s4,562 # 80008000 <etext>
    80000dd6:	04000937          	lui	s2,0x4000
    80000dda:	197d                	addi	s2,s2,-1
    80000ddc:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dde:	0000e997          	auipc	s3,0xe
    80000de2:	ab298993          	addi	s3,s3,-1358 # 8000e890 <tickslock>
      initlock(&p->lock, "proc");
    80000de6:	85da                	mv	a1,s6
    80000de8:	8526                	mv	a0,s1
    80000dea:	00005097          	auipc	ra,0x5
    80000dee:	392080e7          	jalr	914(ra) # 8000617c <initlock>
      p->state = UNUSED;
    80000df2:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000df6:	415487b3          	sub	a5,s1,s5
    80000dfa:	878d                	srai	a5,a5,0x3
    80000dfc:	000a3703          	ld	a4,0(s4)
    80000e00:	02e787b3          	mul	a5,a5,a4
    80000e04:	2785                	addiw	a5,a5,1
    80000e06:	00d7979b          	slliw	a5,a5,0xd
    80000e0a:	40f907b3          	sub	a5,s2,a5
    80000e0e:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e10:	16848493          	addi	s1,s1,360
    80000e14:	fd3499e3          	bne	s1,s3,80000de6 <procinit+0x6e>
  }
}
    80000e18:	70e2                	ld	ra,56(sp)
    80000e1a:	7442                	ld	s0,48(sp)
    80000e1c:	74a2                	ld	s1,40(sp)
    80000e1e:	7902                	ld	s2,32(sp)
    80000e20:	69e2                	ld	s3,24(sp)
    80000e22:	6a42                	ld	s4,16(sp)
    80000e24:	6aa2                	ld	s5,8(sp)
    80000e26:	6b02                	ld	s6,0(sp)
    80000e28:	6121                	addi	sp,sp,64
    80000e2a:	8082                	ret

0000000080000e2c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e2c:	1141                	addi	sp,sp,-16
    80000e2e:	e422                	sd	s0,8(sp)
    80000e30:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e32:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e34:	2501                	sext.w	a0,a0
    80000e36:	6422                	ld	s0,8(sp)
    80000e38:	0141                	addi	sp,sp,16
    80000e3a:	8082                	ret

0000000080000e3c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e3c:	1141                	addi	sp,sp,-16
    80000e3e:	e422                	sd	s0,8(sp)
    80000e40:	0800                	addi	s0,sp,16
    80000e42:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e44:	2781                	sext.w	a5,a5
    80000e46:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e48:	00008517          	auipc	a0,0x8
    80000e4c:	c4850513          	addi	a0,a0,-952 # 80008a90 <cpus>
    80000e50:	953e                	add	a0,a0,a5
    80000e52:	6422                	ld	s0,8(sp)
    80000e54:	0141                	addi	sp,sp,16
    80000e56:	8082                	ret

0000000080000e58 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000e58:	1101                	addi	sp,sp,-32
    80000e5a:	ec06                	sd	ra,24(sp)
    80000e5c:	e822                	sd	s0,16(sp)
    80000e5e:	e426                	sd	s1,8(sp)
    80000e60:	1000                	addi	s0,sp,32
  push_off();
    80000e62:	00005097          	auipc	ra,0x5
    80000e66:	35e080e7          	jalr	862(ra) # 800061c0 <push_off>
    80000e6a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e6c:	2781                	sext.w	a5,a5
    80000e6e:	079e                	slli	a5,a5,0x7
    80000e70:	00008717          	auipc	a4,0x8
    80000e74:	bf070713          	addi	a4,a4,-1040 # 80008a60 <pid_lock>
    80000e78:	97ba                	add	a5,a5,a4
    80000e7a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e7c:	00005097          	auipc	ra,0x5
    80000e80:	3e4080e7          	jalr	996(ra) # 80006260 <pop_off>
  return p;
}
    80000e84:	8526                	mv	a0,s1
    80000e86:	60e2                	ld	ra,24(sp)
    80000e88:	6442                	ld	s0,16(sp)
    80000e8a:	64a2                	ld	s1,8(sp)
    80000e8c:	6105                	addi	sp,sp,32
    80000e8e:	8082                	ret

0000000080000e90 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e90:	1141                	addi	sp,sp,-16
    80000e92:	e406                	sd	ra,8(sp)
    80000e94:	e022                	sd	s0,0(sp)
    80000e96:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e98:	00000097          	auipc	ra,0x0
    80000e9c:	fc0080e7          	jalr	-64(ra) # 80000e58 <myproc>
    80000ea0:	00005097          	auipc	ra,0x5
    80000ea4:	420080e7          	jalr	1056(ra) # 800062c0 <release>

  if (first) {
    80000ea8:	00008797          	auipc	a5,0x8
    80000eac:	b187a783          	lw	a5,-1256(a5) # 800089c0 <first.1692>
    80000eb0:	eb89                	bnez	a5,80000ec2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000eb2:	00001097          	auipc	ra,0x1
    80000eb6:	cd2080e7          	jalr	-814(ra) # 80001b84 <usertrapret>
}
    80000eba:	60a2                	ld	ra,8(sp)
    80000ebc:	6402                	ld	s0,0(sp)
    80000ebe:	0141                	addi	sp,sp,16
    80000ec0:	8082                	ret
    first = 0;
    80000ec2:	00008797          	auipc	a5,0x8
    80000ec6:	ae07af23          	sw	zero,-1282(a5) # 800089c0 <first.1692>
    fsinit(ROOTDEV);
    80000eca:	4505                	li	a0,1
    80000ecc:	00002097          	auipc	ra,0x2
    80000ed0:	a80080e7          	jalr	-1408(ra) # 8000294c <fsinit>
    80000ed4:	bff9                	j	80000eb2 <forkret+0x22>

0000000080000ed6 <allocpid>:
{
    80000ed6:	1101                	addi	sp,sp,-32
    80000ed8:	ec06                	sd	ra,24(sp)
    80000eda:	e822                	sd	s0,16(sp)
    80000edc:	e426                	sd	s1,8(sp)
    80000ede:	e04a                	sd	s2,0(sp)
    80000ee0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ee2:	00008917          	auipc	s2,0x8
    80000ee6:	b7e90913          	addi	s2,s2,-1154 # 80008a60 <pid_lock>
    80000eea:	854a                	mv	a0,s2
    80000eec:	00005097          	auipc	ra,0x5
    80000ef0:	320080e7          	jalr	800(ra) # 8000620c <acquire>
  pid = nextpid;
    80000ef4:	00008797          	auipc	a5,0x8
    80000ef8:	ad078793          	addi	a5,a5,-1328 # 800089c4 <nextpid>
    80000efc:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000efe:	0014871b          	addiw	a4,s1,1
    80000f02:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f04:	854a                	mv	a0,s2
    80000f06:	00005097          	auipc	ra,0x5
    80000f0a:	3ba080e7          	jalr	954(ra) # 800062c0 <release>
}
    80000f0e:	8526                	mv	a0,s1
    80000f10:	60e2                	ld	ra,24(sp)
    80000f12:	6442                	ld	s0,16(sp)
    80000f14:	64a2                	ld	s1,8(sp)
    80000f16:	6902                	ld	s2,0(sp)
    80000f18:	6105                	addi	sp,sp,32
    80000f1a:	8082                	ret

0000000080000f1c <proc_pagetable>:
{
    80000f1c:	1101                	addi	sp,sp,-32
    80000f1e:	ec06                	sd	ra,24(sp)
    80000f20:	e822                	sd	s0,16(sp)
    80000f22:	e426                	sd	s1,8(sp)
    80000f24:	e04a                	sd	s2,0(sp)
    80000f26:	1000                	addi	s0,sp,32
    80000f28:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f2a:	00000097          	auipc	ra,0x0
    80000f2e:	8ac080e7          	jalr	-1876(ra) # 800007d6 <uvmcreate>
    80000f32:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f34:	c121                	beqz	a0,80000f74 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f36:	4729                	li	a4,10
    80000f38:	00006697          	auipc	a3,0x6
    80000f3c:	0c868693          	addi	a3,a3,200 # 80007000 <_trampoline>
    80000f40:	6605                	lui	a2,0x1
    80000f42:	040005b7          	lui	a1,0x4000
    80000f46:	15fd                	addi	a1,a1,-1
    80000f48:	05b2                	slli	a1,a1,0xc
    80000f4a:	fffff097          	auipc	ra,0xfffff
    80000f4e:	602080e7          	jalr	1538(ra) # 8000054c <mappages>
    80000f52:	02054863          	bltz	a0,80000f82 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f56:	4719                	li	a4,6
    80000f58:	05893683          	ld	a3,88(s2)
    80000f5c:	6605                	lui	a2,0x1
    80000f5e:	020005b7          	lui	a1,0x2000
    80000f62:	15fd                	addi	a1,a1,-1
    80000f64:	05b6                	slli	a1,a1,0xd
    80000f66:	8526                	mv	a0,s1
    80000f68:	fffff097          	auipc	ra,0xfffff
    80000f6c:	5e4080e7          	jalr	1508(ra) # 8000054c <mappages>
    80000f70:	02054163          	bltz	a0,80000f92 <proc_pagetable+0x76>
}
    80000f74:	8526                	mv	a0,s1
    80000f76:	60e2                	ld	ra,24(sp)
    80000f78:	6442                	ld	s0,16(sp)
    80000f7a:	64a2                	ld	s1,8(sp)
    80000f7c:	6902                	ld	s2,0(sp)
    80000f7e:	6105                	addi	sp,sp,32
    80000f80:	8082                	ret
    uvmfree(pagetable, 0);
    80000f82:	4581                	li	a1,0
    80000f84:	8526                	mv	a0,s1
    80000f86:	00000097          	auipc	ra,0x0
    80000f8a:	a54080e7          	jalr	-1452(ra) # 800009da <uvmfree>
    return 0;
    80000f8e:	4481                	li	s1,0
    80000f90:	b7d5                	j	80000f74 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f92:	4681                	li	a3,0
    80000f94:	4605                	li	a2,1
    80000f96:	040005b7          	lui	a1,0x4000
    80000f9a:	15fd                	addi	a1,a1,-1
    80000f9c:	05b2                	slli	a1,a1,0xc
    80000f9e:	8526                	mv	a0,s1
    80000fa0:	fffff097          	auipc	ra,0xfffff
    80000fa4:	772080e7          	jalr	1906(ra) # 80000712 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fa8:	4581                	li	a1,0
    80000faa:	8526                	mv	a0,s1
    80000fac:	00000097          	auipc	ra,0x0
    80000fb0:	a2e080e7          	jalr	-1490(ra) # 800009da <uvmfree>
    return 0;
    80000fb4:	4481                	li	s1,0
    80000fb6:	bf7d                	j	80000f74 <proc_pagetable+0x58>

0000000080000fb8 <proc_freepagetable>:
{
    80000fb8:	1101                	addi	sp,sp,-32
    80000fba:	ec06                	sd	ra,24(sp)
    80000fbc:	e822                	sd	s0,16(sp)
    80000fbe:	e426                	sd	s1,8(sp)
    80000fc0:	e04a                	sd	s2,0(sp)
    80000fc2:	1000                	addi	s0,sp,32
    80000fc4:	84aa                	mv	s1,a0
    80000fc6:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fc8:	4681                	li	a3,0
    80000fca:	4605                	li	a2,1
    80000fcc:	040005b7          	lui	a1,0x4000
    80000fd0:	15fd                	addi	a1,a1,-1
    80000fd2:	05b2                	slli	a1,a1,0xc
    80000fd4:	fffff097          	auipc	ra,0xfffff
    80000fd8:	73e080e7          	jalr	1854(ra) # 80000712 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fdc:	4681                	li	a3,0
    80000fde:	4605                	li	a2,1
    80000fe0:	020005b7          	lui	a1,0x2000
    80000fe4:	15fd                	addi	a1,a1,-1
    80000fe6:	05b6                	slli	a1,a1,0xd
    80000fe8:	8526                	mv	a0,s1
    80000fea:	fffff097          	auipc	ra,0xfffff
    80000fee:	728080e7          	jalr	1832(ra) # 80000712 <uvmunmap>
  uvmfree(pagetable, sz);
    80000ff2:	85ca                	mv	a1,s2
    80000ff4:	8526                	mv	a0,s1
    80000ff6:	00000097          	auipc	ra,0x0
    80000ffa:	9e4080e7          	jalr	-1564(ra) # 800009da <uvmfree>
}
    80000ffe:	60e2                	ld	ra,24(sp)
    80001000:	6442                	ld	s0,16(sp)
    80001002:	64a2                	ld	s1,8(sp)
    80001004:	6902                	ld	s2,0(sp)
    80001006:	6105                	addi	sp,sp,32
    80001008:	8082                	ret

000000008000100a <freeproc>:
{
    8000100a:	1101                	addi	sp,sp,-32
    8000100c:	ec06                	sd	ra,24(sp)
    8000100e:	e822                	sd	s0,16(sp)
    80001010:	e426                	sd	s1,8(sp)
    80001012:	1000                	addi	s0,sp,32
    80001014:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001016:	6d28                	ld	a0,88(a0)
    80001018:	c509                	beqz	a0,80001022 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000101a:	fffff097          	auipc	ra,0xfffff
    8000101e:	002080e7          	jalr	2(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001022:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001026:	68a8                	ld	a0,80(s1)
    80001028:	c511                	beqz	a0,80001034 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000102a:	64ac                	ld	a1,72(s1)
    8000102c:	00000097          	auipc	ra,0x0
    80001030:	f8c080e7          	jalr	-116(ra) # 80000fb8 <proc_freepagetable>
  p->pagetable = 0;
    80001034:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001038:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000103c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001040:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001044:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001048:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000104c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001050:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001054:	0004ac23          	sw	zero,24(s1)
}
    80001058:	60e2                	ld	ra,24(sp)
    8000105a:	6442                	ld	s0,16(sp)
    8000105c:	64a2                	ld	s1,8(sp)
    8000105e:	6105                	addi	sp,sp,32
    80001060:	8082                	ret

0000000080001062 <allocproc>:
{
    80001062:	1101                	addi	sp,sp,-32
    80001064:	ec06                	sd	ra,24(sp)
    80001066:	e822                	sd	s0,16(sp)
    80001068:	e426                	sd	s1,8(sp)
    8000106a:	e04a                	sd	s2,0(sp)
    8000106c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000106e:	00008497          	auipc	s1,0x8
    80001072:	e2248493          	addi	s1,s1,-478 # 80008e90 <proc>
    80001076:	0000e917          	auipc	s2,0xe
    8000107a:	81a90913          	addi	s2,s2,-2022 # 8000e890 <tickslock>
    acquire(&p->lock);
    8000107e:	8526                	mv	a0,s1
    80001080:	00005097          	auipc	ra,0x5
    80001084:	18c080e7          	jalr	396(ra) # 8000620c <acquire>
    if(p->state == UNUSED) {
    80001088:	4c9c                	lw	a5,24(s1)
    8000108a:	cf81                	beqz	a5,800010a2 <allocproc+0x40>
      release(&p->lock);
    8000108c:	8526                	mv	a0,s1
    8000108e:	00005097          	auipc	ra,0x5
    80001092:	232080e7          	jalr	562(ra) # 800062c0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001096:	16848493          	addi	s1,s1,360
    8000109a:	ff2492e3          	bne	s1,s2,8000107e <allocproc+0x1c>
  return 0;
    8000109e:	4481                	li	s1,0
    800010a0:	a889                	j	800010f2 <allocproc+0x90>
  p->pid = allocpid();
    800010a2:	00000097          	auipc	ra,0x0
    800010a6:	e34080e7          	jalr	-460(ra) # 80000ed6 <allocpid>
    800010aa:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010ac:	4785                	li	a5,1
    800010ae:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010b0:	fffff097          	auipc	ra,0xfffff
    800010b4:	068080e7          	jalr	104(ra) # 80000118 <kalloc>
    800010b8:	892a                	mv	s2,a0
    800010ba:	eca8                	sd	a0,88(s1)
    800010bc:	c131                	beqz	a0,80001100 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010be:	8526                	mv	a0,s1
    800010c0:	00000097          	auipc	ra,0x0
    800010c4:	e5c080e7          	jalr	-420(ra) # 80000f1c <proc_pagetable>
    800010c8:	892a                	mv	s2,a0
    800010ca:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010cc:	c531                	beqz	a0,80001118 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010ce:	07000613          	li	a2,112
    800010d2:	4581                	li	a1,0
    800010d4:	06048513          	addi	a0,s1,96
    800010d8:	fffff097          	auipc	ra,0xfffff
    800010dc:	0a0080e7          	jalr	160(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800010e0:	00000797          	auipc	a5,0x0
    800010e4:	db078793          	addi	a5,a5,-592 # 80000e90 <forkret>
    800010e8:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010ea:	60bc                	ld	a5,64(s1)
    800010ec:	6705                	lui	a4,0x1
    800010ee:	97ba                	add	a5,a5,a4
    800010f0:	f4bc                	sd	a5,104(s1)
}
    800010f2:	8526                	mv	a0,s1
    800010f4:	60e2                	ld	ra,24(sp)
    800010f6:	6442                	ld	s0,16(sp)
    800010f8:	64a2                	ld	s1,8(sp)
    800010fa:	6902                	ld	s2,0(sp)
    800010fc:	6105                	addi	sp,sp,32
    800010fe:	8082                	ret
    freeproc(p);
    80001100:	8526                	mv	a0,s1
    80001102:	00000097          	auipc	ra,0x0
    80001106:	f08080e7          	jalr	-248(ra) # 8000100a <freeproc>
    release(&p->lock);
    8000110a:	8526                	mv	a0,s1
    8000110c:	00005097          	auipc	ra,0x5
    80001110:	1b4080e7          	jalr	436(ra) # 800062c0 <release>
    return 0;
    80001114:	84ca                	mv	s1,s2
    80001116:	bff1                	j	800010f2 <allocproc+0x90>
    freeproc(p);
    80001118:	8526                	mv	a0,s1
    8000111a:	00000097          	auipc	ra,0x0
    8000111e:	ef0080e7          	jalr	-272(ra) # 8000100a <freeproc>
    release(&p->lock);
    80001122:	8526                	mv	a0,s1
    80001124:	00005097          	auipc	ra,0x5
    80001128:	19c080e7          	jalr	412(ra) # 800062c0 <release>
    return 0;
    8000112c:	84ca                	mv	s1,s2
    8000112e:	b7d1                	j	800010f2 <allocproc+0x90>

0000000080001130 <userinit>:
{
    80001130:	1101                	addi	sp,sp,-32
    80001132:	ec06                	sd	ra,24(sp)
    80001134:	e822                	sd	s0,16(sp)
    80001136:	e426                	sd	s1,8(sp)
    80001138:	1000                	addi	s0,sp,32
  p = allocproc();
    8000113a:	00000097          	auipc	ra,0x0
    8000113e:	f28080e7          	jalr	-216(ra) # 80001062 <allocproc>
    80001142:	84aa                	mv	s1,a0
  initproc = p;
    80001144:	00008797          	auipc	a5,0x8
    80001148:	8ca7be23          	sd	a0,-1828(a5) # 80008a20 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    8000114c:	03400613          	li	a2,52
    80001150:	00008597          	auipc	a1,0x8
    80001154:	88058593          	addi	a1,a1,-1920 # 800089d0 <initcode>
    80001158:	6928                	ld	a0,80(a0)
    8000115a:	fffff097          	auipc	ra,0xfffff
    8000115e:	6aa080e7          	jalr	1706(ra) # 80000804 <uvmfirst>
  p->sz = PGSIZE;
    80001162:	6785                	lui	a5,0x1
    80001164:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001166:	6cb8                	ld	a4,88(s1)
    80001168:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000116c:	6cb8                	ld	a4,88(s1)
    8000116e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001170:	4641                	li	a2,16
    80001172:	00007597          	auipc	a1,0x7
    80001176:	00e58593          	addi	a1,a1,14 # 80008180 <etext+0x180>
    8000117a:	15848513          	addi	a0,s1,344
    8000117e:	fffff097          	auipc	ra,0xfffff
    80001182:	14c080e7          	jalr	332(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    80001186:	00007517          	auipc	a0,0x7
    8000118a:	00a50513          	addi	a0,a0,10 # 80008190 <etext+0x190>
    8000118e:	00002097          	auipc	ra,0x2
    80001192:	1e0080e7          	jalr	480(ra) # 8000336e <namei>
    80001196:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000119a:	478d                	li	a5,3
    8000119c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000119e:	8526                	mv	a0,s1
    800011a0:	00005097          	auipc	ra,0x5
    800011a4:	120080e7          	jalr	288(ra) # 800062c0 <release>
}
    800011a8:	60e2                	ld	ra,24(sp)
    800011aa:	6442                	ld	s0,16(sp)
    800011ac:	64a2                	ld	s1,8(sp)
    800011ae:	6105                	addi	sp,sp,32
    800011b0:	8082                	ret

00000000800011b2 <growproc>:
{
    800011b2:	1101                	addi	sp,sp,-32
    800011b4:	ec06                	sd	ra,24(sp)
    800011b6:	e822                	sd	s0,16(sp)
    800011b8:	e426                	sd	s1,8(sp)
    800011ba:	e04a                	sd	s2,0(sp)
    800011bc:	1000                	addi	s0,sp,32
    800011be:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800011c0:	00000097          	auipc	ra,0x0
    800011c4:	c98080e7          	jalr	-872(ra) # 80000e58 <myproc>
    800011c8:	84aa                	mv	s1,a0
  sz = p->sz;
    800011ca:	652c                	ld	a1,72(a0)
  if(n > 0){
    800011cc:	01204c63          	bgtz	s2,800011e4 <growproc+0x32>
  } else if(n < 0){
    800011d0:	02094663          	bltz	s2,800011fc <growproc+0x4a>
  p->sz = sz;
    800011d4:	e4ac                	sd	a1,72(s1)
  return 0;
    800011d6:	4501                	li	a0,0
}
    800011d8:	60e2                	ld	ra,24(sp)
    800011da:	6442                	ld	s0,16(sp)
    800011dc:	64a2                	ld	s1,8(sp)
    800011de:	6902                	ld	s2,0(sp)
    800011e0:	6105                	addi	sp,sp,32
    800011e2:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800011e4:	4691                	li	a3,4
    800011e6:	00b90633          	add	a2,s2,a1
    800011ea:	6928                	ld	a0,80(a0)
    800011ec:	fffff097          	auipc	ra,0xfffff
    800011f0:	6d2080e7          	jalr	1746(ra) # 800008be <uvmalloc>
    800011f4:	85aa                	mv	a1,a0
    800011f6:	fd79                	bnez	a0,800011d4 <growproc+0x22>
      return -1;
    800011f8:	557d                	li	a0,-1
    800011fa:	bff9                	j	800011d8 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011fc:	00b90633          	add	a2,s2,a1
    80001200:	6928                	ld	a0,80(a0)
    80001202:	fffff097          	auipc	ra,0xfffff
    80001206:	674080e7          	jalr	1652(ra) # 80000876 <uvmdealloc>
    8000120a:	85aa                	mv	a1,a0
    8000120c:	b7e1                	j	800011d4 <growproc+0x22>

000000008000120e <fork>:
{
    8000120e:	7179                	addi	sp,sp,-48
    80001210:	f406                	sd	ra,40(sp)
    80001212:	f022                	sd	s0,32(sp)
    80001214:	ec26                	sd	s1,24(sp)
    80001216:	e84a                	sd	s2,16(sp)
    80001218:	e44e                	sd	s3,8(sp)
    8000121a:	e052                	sd	s4,0(sp)
    8000121c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000121e:	00000097          	auipc	ra,0x0
    80001222:	c3a080e7          	jalr	-966(ra) # 80000e58 <myproc>
    80001226:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001228:	00000097          	auipc	ra,0x0
    8000122c:	e3a080e7          	jalr	-454(ra) # 80001062 <allocproc>
    80001230:	10050f63          	beqz	a0,8000134e <fork+0x140>
    80001234:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001236:	04893603          	ld	a2,72(s2)
    8000123a:	692c                	ld	a1,80(a0)
    8000123c:	05093503          	ld	a0,80(s2)
    80001240:	fffff097          	auipc	ra,0xfffff
    80001244:	7d2080e7          	jalr	2002(ra) # 80000a12 <uvmcopy>
    80001248:	04054663          	bltz	a0,80001294 <fork+0x86>
  np->sz = p->sz;
    8000124c:	04893783          	ld	a5,72(s2)
    80001250:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001254:	05893683          	ld	a3,88(s2)
    80001258:	87b6                	mv	a5,a3
    8000125a:	0589b703          	ld	a4,88(s3)
    8000125e:	12068693          	addi	a3,a3,288
    80001262:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001266:	6788                	ld	a0,8(a5)
    80001268:	6b8c                	ld	a1,16(a5)
    8000126a:	6f90                	ld	a2,24(a5)
    8000126c:	01073023          	sd	a6,0(a4)
    80001270:	e708                	sd	a0,8(a4)
    80001272:	eb0c                	sd	a1,16(a4)
    80001274:	ef10                	sd	a2,24(a4)
    80001276:	02078793          	addi	a5,a5,32
    8000127a:	02070713          	addi	a4,a4,32
    8000127e:	fed792e3          	bne	a5,a3,80001262 <fork+0x54>
  np->trapframe->a0 = 0;
    80001282:	0589b783          	ld	a5,88(s3)
    80001286:	0607b823          	sd	zero,112(a5)
    8000128a:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    8000128e:	15000a13          	li	s4,336
    80001292:	a03d                	j	800012c0 <fork+0xb2>
    freeproc(np);
    80001294:	854e                	mv	a0,s3
    80001296:	00000097          	auipc	ra,0x0
    8000129a:	d74080e7          	jalr	-652(ra) # 8000100a <freeproc>
    release(&np->lock);
    8000129e:	854e                	mv	a0,s3
    800012a0:	00005097          	auipc	ra,0x5
    800012a4:	020080e7          	jalr	32(ra) # 800062c0 <release>
    return -1;
    800012a8:	5a7d                	li	s4,-1
    800012aa:	a849                	j	8000133c <fork+0x12e>
      np->ofile[i] = filedup(p->ofile[i]);
    800012ac:	00002097          	auipc	ra,0x2
    800012b0:	758080e7          	jalr	1880(ra) # 80003a04 <filedup>
    800012b4:	009987b3          	add	a5,s3,s1
    800012b8:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800012ba:	04a1                	addi	s1,s1,8
    800012bc:	01448763          	beq	s1,s4,800012ca <fork+0xbc>
    if(p->ofile[i])
    800012c0:	009907b3          	add	a5,s2,s1
    800012c4:	6388                	ld	a0,0(a5)
    800012c6:	f17d                	bnez	a0,800012ac <fork+0x9e>
    800012c8:	bfcd                	j	800012ba <fork+0xac>
  np->cwd = idup(p->cwd);
    800012ca:	15093503          	ld	a0,336(s2)
    800012ce:	00002097          	auipc	ra,0x2
    800012d2:	8bc080e7          	jalr	-1860(ra) # 80002b8a <idup>
    800012d6:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012da:	4641                	li	a2,16
    800012dc:	15890593          	addi	a1,s2,344
    800012e0:	15898513          	addi	a0,s3,344
    800012e4:	fffff097          	auipc	ra,0xfffff
    800012e8:	fe6080e7          	jalr	-26(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    800012ec:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    800012f0:	854e                	mv	a0,s3
    800012f2:	00005097          	auipc	ra,0x5
    800012f6:	fce080e7          	jalr	-50(ra) # 800062c0 <release>
  np->tracemask = p->tracemask;
    800012fa:	03492783          	lw	a5,52(s2)
    800012fe:	02f9aa23          	sw	a5,52(s3)
  acquire(&wait_lock);
    80001302:	00007497          	auipc	s1,0x7
    80001306:	77648493          	addi	s1,s1,1910 # 80008a78 <wait_lock>
    8000130a:	8526                	mv	a0,s1
    8000130c:	00005097          	auipc	ra,0x5
    80001310:	f00080e7          	jalr	-256(ra) # 8000620c <acquire>
  np->parent = p;
    80001314:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001318:	8526                	mv	a0,s1
    8000131a:	00005097          	auipc	ra,0x5
    8000131e:	fa6080e7          	jalr	-90(ra) # 800062c0 <release>
  acquire(&np->lock);
    80001322:	854e                	mv	a0,s3
    80001324:	00005097          	auipc	ra,0x5
    80001328:	ee8080e7          	jalr	-280(ra) # 8000620c <acquire>
  np->state = RUNNABLE;
    8000132c:	478d                	li	a5,3
    8000132e:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001332:	854e                	mv	a0,s3
    80001334:	00005097          	auipc	ra,0x5
    80001338:	f8c080e7          	jalr	-116(ra) # 800062c0 <release>
}
    8000133c:	8552                	mv	a0,s4
    8000133e:	70a2                	ld	ra,40(sp)
    80001340:	7402                	ld	s0,32(sp)
    80001342:	64e2                	ld	s1,24(sp)
    80001344:	6942                	ld	s2,16(sp)
    80001346:	69a2                	ld	s3,8(sp)
    80001348:	6a02                	ld	s4,0(sp)
    8000134a:	6145                	addi	sp,sp,48
    8000134c:	8082                	ret
    return -1;
    8000134e:	5a7d                	li	s4,-1
    80001350:	b7f5                	j	8000133c <fork+0x12e>

0000000080001352 <numprocesses>:
{
    80001352:	7179                	addi	sp,sp,-48
    80001354:	f406                	sd	ra,40(sp)
    80001356:	f022                	sd	s0,32(sp)
    80001358:	ec26                	sd	s1,24(sp)
    8000135a:	e84a                	sd	s2,16(sp)
    8000135c:	e44e                	sd	s3,8(sp)
    8000135e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001360:	00000097          	auipc	ra,0x0
    80001364:	af8080e7          	jalr	-1288(ra) # 80000e58 <myproc>
  int numUsed = 0;
    80001368:	4901                	li	s2,0
  for(p = proc; p < &proc[NPROC]; p++) {
    8000136a:	00008497          	auipc	s1,0x8
    8000136e:	b2648493          	addi	s1,s1,-1242 # 80008e90 <proc>
    80001372:	0000d997          	auipc	s3,0xd
    80001376:	51e98993          	addi	s3,s3,1310 # 8000e890 <tickslock>
    8000137a:	a029                	j	80001384 <numprocesses+0x32>
    8000137c:	16848493          	addi	s1,s1,360
    80001380:	01348b63          	beq	s1,s3,80001396 <numprocesses+0x44>
    acquire(&p->lock);
    80001384:	8526                	mv	a0,s1
    80001386:	00005097          	auipc	ra,0x5
    8000138a:	e86080e7          	jalr	-378(ra) # 8000620c <acquire>
    if(p->state != UNUSED) {
    8000138e:	4c9c                	lw	a5,24(s1)
    80001390:	d7f5                	beqz	a5,8000137c <numprocesses+0x2a>
      numUsed++;
    80001392:	2905                	addiw	s2,s2,1
    80001394:	b7e5                	j	8000137c <numprocesses+0x2a>
}
    80001396:	854a                	mv	a0,s2
    80001398:	70a2                	ld	ra,40(sp)
    8000139a:	7402                	ld	s0,32(sp)
    8000139c:	64e2                	ld	s1,24(sp)
    8000139e:	6942                	ld	s2,16(sp)
    800013a0:	69a2                	ld	s3,8(sp)
    800013a2:	6145                	addi	sp,sp,48
    800013a4:	8082                	ret

00000000800013a6 <trace>:
{
    800013a6:	1101                	addi	sp,sp,-32
    800013a8:	ec06                	sd	ra,24(sp)
    800013aa:	e822                	sd	s0,16(sp)
    800013ac:	e426                	sd	s1,8(sp)
    800013ae:	1000                	addi	s0,sp,32
    800013b0:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800013b2:	00000097          	auipc	ra,0x0
    800013b6:	aa6080e7          	jalr	-1370(ra) # 80000e58 <myproc>
  p->tracemask  = mask;
    800013ba:	d944                	sw	s1,52(a0)
}
    800013bc:	60e2                	ld	ra,24(sp)
    800013be:	6442                	ld	s0,16(sp)
    800013c0:	64a2                	ld	s1,8(sp)
    800013c2:	6105                	addi	sp,sp,32
    800013c4:	8082                	ret

00000000800013c6 <scheduler>:
{
    800013c6:	7139                	addi	sp,sp,-64
    800013c8:	fc06                	sd	ra,56(sp)
    800013ca:	f822                	sd	s0,48(sp)
    800013cc:	f426                	sd	s1,40(sp)
    800013ce:	f04a                	sd	s2,32(sp)
    800013d0:	ec4e                	sd	s3,24(sp)
    800013d2:	e852                	sd	s4,16(sp)
    800013d4:	e456                	sd	s5,8(sp)
    800013d6:	e05a                	sd	s6,0(sp)
    800013d8:	0080                	addi	s0,sp,64
    800013da:	8792                	mv	a5,tp
  int id = r_tp();
    800013dc:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013de:	00779a93          	slli	s5,a5,0x7
    800013e2:	00007717          	auipc	a4,0x7
    800013e6:	67e70713          	addi	a4,a4,1662 # 80008a60 <pid_lock>
    800013ea:	9756                	add	a4,a4,s5
    800013ec:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013f0:	00007717          	auipc	a4,0x7
    800013f4:	6a870713          	addi	a4,a4,1704 # 80008a98 <cpus+0x8>
    800013f8:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013fa:	498d                	li	s3,3
        p->state = RUNNING;
    800013fc:	4b11                	li	s6,4
        c->proc = p;
    800013fe:	079e                	slli	a5,a5,0x7
    80001400:	00007a17          	auipc	s4,0x7
    80001404:	660a0a13          	addi	s4,s4,1632 # 80008a60 <pid_lock>
    80001408:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000140a:	0000d917          	auipc	s2,0xd
    8000140e:	48690913          	addi	s2,s2,1158 # 8000e890 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001412:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001416:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000141a:	10079073          	csrw	sstatus,a5
    8000141e:	00008497          	auipc	s1,0x8
    80001422:	a7248493          	addi	s1,s1,-1422 # 80008e90 <proc>
    80001426:	a03d                	j	80001454 <scheduler+0x8e>
        p->state = RUNNING;
    80001428:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000142c:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001430:	06048593          	addi	a1,s1,96
    80001434:	8556                	mv	a0,s5
    80001436:	00000097          	auipc	ra,0x0
    8000143a:	6a4080e7          	jalr	1700(ra) # 80001ada <swtch>
        c->proc = 0;
    8000143e:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80001442:	8526                	mv	a0,s1
    80001444:	00005097          	auipc	ra,0x5
    80001448:	e7c080e7          	jalr	-388(ra) # 800062c0 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000144c:	16848493          	addi	s1,s1,360
    80001450:	fd2481e3          	beq	s1,s2,80001412 <scheduler+0x4c>
      acquire(&p->lock);
    80001454:	8526                	mv	a0,s1
    80001456:	00005097          	auipc	ra,0x5
    8000145a:	db6080e7          	jalr	-586(ra) # 8000620c <acquire>
      if(p->state == RUNNABLE) {
    8000145e:	4c9c                	lw	a5,24(s1)
    80001460:	ff3791e3          	bne	a5,s3,80001442 <scheduler+0x7c>
    80001464:	b7d1                	j	80001428 <scheduler+0x62>

0000000080001466 <sched>:
{
    80001466:	7179                	addi	sp,sp,-48
    80001468:	f406                	sd	ra,40(sp)
    8000146a:	f022                	sd	s0,32(sp)
    8000146c:	ec26                	sd	s1,24(sp)
    8000146e:	e84a                	sd	s2,16(sp)
    80001470:	e44e                	sd	s3,8(sp)
    80001472:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001474:	00000097          	auipc	ra,0x0
    80001478:	9e4080e7          	jalr	-1564(ra) # 80000e58 <myproc>
    8000147c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000147e:	00005097          	auipc	ra,0x5
    80001482:	d14080e7          	jalr	-748(ra) # 80006192 <holding>
    80001486:	c93d                	beqz	a0,800014fc <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001488:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000148a:	2781                	sext.w	a5,a5
    8000148c:	079e                	slli	a5,a5,0x7
    8000148e:	00007717          	auipc	a4,0x7
    80001492:	5d270713          	addi	a4,a4,1490 # 80008a60 <pid_lock>
    80001496:	97ba                	add	a5,a5,a4
    80001498:	0a87a703          	lw	a4,168(a5)
    8000149c:	4785                	li	a5,1
    8000149e:	06f71763          	bne	a4,a5,8000150c <sched+0xa6>
  if(p->state == RUNNING)
    800014a2:	4c98                	lw	a4,24(s1)
    800014a4:	4791                	li	a5,4
    800014a6:	06f70b63          	beq	a4,a5,8000151c <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014aa:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014ae:	8b89                	andi	a5,a5,2
  if(intr_get())
    800014b0:	efb5                	bnez	a5,8000152c <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014b2:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014b4:	00007917          	auipc	s2,0x7
    800014b8:	5ac90913          	addi	s2,s2,1452 # 80008a60 <pid_lock>
    800014bc:	2781                	sext.w	a5,a5
    800014be:	079e                	slli	a5,a5,0x7
    800014c0:	97ca                	add	a5,a5,s2
    800014c2:	0ac7a983          	lw	s3,172(a5)
    800014c6:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014c8:	2781                	sext.w	a5,a5
    800014ca:	079e                	slli	a5,a5,0x7
    800014cc:	00007597          	auipc	a1,0x7
    800014d0:	5cc58593          	addi	a1,a1,1484 # 80008a98 <cpus+0x8>
    800014d4:	95be                	add	a1,a1,a5
    800014d6:	06048513          	addi	a0,s1,96
    800014da:	00000097          	auipc	ra,0x0
    800014de:	600080e7          	jalr	1536(ra) # 80001ada <swtch>
    800014e2:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014e4:	2781                	sext.w	a5,a5
    800014e6:	079e                	slli	a5,a5,0x7
    800014e8:	97ca                	add	a5,a5,s2
    800014ea:	0b37a623          	sw	s3,172(a5)
}
    800014ee:	70a2                	ld	ra,40(sp)
    800014f0:	7402                	ld	s0,32(sp)
    800014f2:	64e2                	ld	s1,24(sp)
    800014f4:	6942                	ld	s2,16(sp)
    800014f6:	69a2                	ld	s3,8(sp)
    800014f8:	6145                	addi	sp,sp,48
    800014fa:	8082                	ret
    panic("sched p->lock");
    800014fc:	00007517          	auipc	a0,0x7
    80001500:	c9c50513          	addi	a0,a0,-868 # 80008198 <etext+0x198>
    80001504:	00004097          	auipc	ra,0x4
    80001508:	7be080e7          	jalr	1982(ra) # 80005cc2 <panic>
    panic("sched locks");
    8000150c:	00007517          	auipc	a0,0x7
    80001510:	c9c50513          	addi	a0,a0,-868 # 800081a8 <etext+0x1a8>
    80001514:	00004097          	auipc	ra,0x4
    80001518:	7ae080e7          	jalr	1966(ra) # 80005cc2 <panic>
    panic("sched running");
    8000151c:	00007517          	auipc	a0,0x7
    80001520:	c9c50513          	addi	a0,a0,-868 # 800081b8 <etext+0x1b8>
    80001524:	00004097          	auipc	ra,0x4
    80001528:	79e080e7          	jalr	1950(ra) # 80005cc2 <panic>
    panic("sched interruptible");
    8000152c:	00007517          	auipc	a0,0x7
    80001530:	c9c50513          	addi	a0,a0,-868 # 800081c8 <etext+0x1c8>
    80001534:	00004097          	auipc	ra,0x4
    80001538:	78e080e7          	jalr	1934(ra) # 80005cc2 <panic>

000000008000153c <yield>:
{
    8000153c:	1101                	addi	sp,sp,-32
    8000153e:	ec06                	sd	ra,24(sp)
    80001540:	e822                	sd	s0,16(sp)
    80001542:	e426                	sd	s1,8(sp)
    80001544:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001546:	00000097          	auipc	ra,0x0
    8000154a:	912080e7          	jalr	-1774(ra) # 80000e58 <myproc>
    8000154e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001550:	00005097          	auipc	ra,0x5
    80001554:	cbc080e7          	jalr	-836(ra) # 8000620c <acquire>
  p->state = RUNNABLE;
    80001558:	478d                	li	a5,3
    8000155a:	cc9c                	sw	a5,24(s1)
  sched();
    8000155c:	00000097          	auipc	ra,0x0
    80001560:	f0a080e7          	jalr	-246(ra) # 80001466 <sched>
  release(&p->lock);
    80001564:	8526                	mv	a0,s1
    80001566:	00005097          	auipc	ra,0x5
    8000156a:	d5a080e7          	jalr	-678(ra) # 800062c0 <release>
}
    8000156e:	60e2                	ld	ra,24(sp)
    80001570:	6442                	ld	s0,16(sp)
    80001572:	64a2                	ld	s1,8(sp)
    80001574:	6105                	addi	sp,sp,32
    80001576:	8082                	ret

0000000080001578 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001578:	7179                	addi	sp,sp,-48
    8000157a:	f406                	sd	ra,40(sp)
    8000157c:	f022                	sd	s0,32(sp)
    8000157e:	ec26                	sd	s1,24(sp)
    80001580:	e84a                	sd	s2,16(sp)
    80001582:	e44e                	sd	s3,8(sp)
    80001584:	1800                	addi	s0,sp,48
    80001586:	89aa                	mv	s3,a0
    80001588:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000158a:	00000097          	auipc	ra,0x0
    8000158e:	8ce080e7          	jalr	-1842(ra) # 80000e58 <myproc>
    80001592:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001594:	00005097          	auipc	ra,0x5
    80001598:	c78080e7          	jalr	-904(ra) # 8000620c <acquire>
  release(lk);
    8000159c:	854a                	mv	a0,s2
    8000159e:	00005097          	auipc	ra,0x5
    800015a2:	d22080e7          	jalr	-734(ra) # 800062c0 <release>

  // Go to sleep.
  p->chan = chan;
    800015a6:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800015aa:	4789                	li	a5,2
    800015ac:	cc9c                	sw	a5,24(s1)

  sched();
    800015ae:	00000097          	auipc	ra,0x0
    800015b2:	eb8080e7          	jalr	-328(ra) # 80001466 <sched>

  // Tidy up.
  p->chan = 0;
    800015b6:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015ba:	8526                	mv	a0,s1
    800015bc:	00005097          	auipc	ra,0x5
    800015c0:	d04080e7          	jalr	-764(ra) # 800062c0 <release>
  acquire(lk);
    800015c4:	854a                	mv	a0,s2
    800015c6:	00005097          	auipc	ra,0x5
    800015ca:	c46080e7          	jalr	-954(ra) # 8000620c <acquire>
}
    800015ce:	70a2                	ld	ra,40(sp)
    800015d0:	7402                	ld	s0,32(sp)
    800015d2:	64e2                	ld	s1,24(sp)
    800015d4:	6942                	ld	s2,16(sp)
    800015d6:	69a2                	ld	s3,8(sp)
    800015d8:	6145                	addi	sp,sp,48
    800015da:	8082                	ret

00000000800015dc <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800015dc:	7139                	addi	sp,sp,-64
    800015de:	fc06                	sd	ra,56(sp)
    800015e0:	f822                	sd	s0,48(sp)
    800015e2:	f426                	sd	s1,40(sp)
    800015e4:	f04a                	sd	s2,32(sp)
    800015e6:	ec4e                	sd	s3,24(sp)
    800015e8:	e852                	sd	s4,16(sp)
    800015ea:	e456                	sd	s5,8(sp)
    800015ec:	0080                	addi	s0,sp,64
    800015ee:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800015f0:	00008497          	auipc	s1,0x8
    800015f4:	8a048493          	addi	s1,s1,-1888 # 80008e90 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800015f8:	4989                	li	s3,2
        p->state = RUNNABLE;
    800015fa:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800015fc:	0000d917          	auipc	s2,0xd
    80001600:	29490913          	addi	s2,s2,660 # 8000e890 <tickslock>
    80001604:	a821                	j	8000161c <wakeup+0x40>
        p->state = RUNNABLE;
    80001606:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    8000160a:	8526                	mv	a0,s1
    8000160c:	00005097          	auipc	ra,0x5
    80001610:	cb4080e7          	jalr	-844(ra) # 800062c0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001614:	16848493          	addi	s1,s1,360
    80001618:	03248463          	beq	s1,s2,80001640 <wakeup+0x64>
    if(p != myproc()){
    8000161c:	00000097          	auipc	ra,0x0
    80001620:	83c080e7          	jalr	-1988(ra) # 80000e58 <myproc>
    80001624:	fea488e3          	beq	s1,a0,80001614 <wakeup+0x38>
      acquire(&p->lock);
    80001628:	8526                	mv	a0,s1
    8000162a:	00005097          	auipc	ra,0x5
    8000162e:	be2080e7          	jalr	-1054(ra) # 8000620c <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001632:	4c9c                	lw	a5,24(s1)
    80001634:	fd379be3          	bne	a5,s3,8000160a <wakeup+0x2e>
    80001638:	709c                	ld	a5,32(s1)
    8000163a:	fd4798e3          	bne	a5,s4,8000160a <wakeup+0x2e>
    8000163e:	b7e1                	j	80001606 <wakeup+0x2a>
    }
  }
}
    80001640:	70e2                	ld	ra,56(sp)
    80001642:	7442                	ld	s0,48(sp)
    80001644:	74a2                	ld	s1,40(sp)
    80001646:	7902                	ld	s2,32(sp)
    80001648:	69e2                	ld	s3,24(sp)
    8000164a:	6a42                	ld	s4,16(sp)
    8000164c:	6aa2                	ld	s5,8(sp)
    8000164e:	6121                	addi	sp,sp,64
    80001650:	8082                	ret

0000000080001652 <reparent>:
{
    80001652:	7179                	addi	sp,sp,-48
    80001654:	f406                	sd	ra,40(sp)
    80001656:	f022                	sd	s0,32(sp)
    80001658:	ec26                	sd	s1,24(sp)
    8000165a:	e84a                	sd	s2,16(sp)
    8000165c:	e44e                	sd	s3,8(sp)
    8000165e:	e052                	sd	s4,0(sp)
    80001660:	1800                	addi	s0,sp,48
    80001662:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001664:	00008497          	auipc	s1,0x8
    80001668:	82c48493          	addi	s1,s1,-2004 # 80008e90 <proc>
      pp->parent = initproc;
    8000166c:	00007a17          	auipc	s4,0x7
    80001670:	3b4a0a13          	addi	s4,s4,948 # 80008a20 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001674:	0000d997          	auipc	s3,0xd
    80001678:	21c98993          	addi	s3,s3,540 # 8000e890 <tickslock>
    8000167c:	a029                	j	80001686 <reparent+0x34>
    8000167e:	16848493          	addi	s1,s1,360
    80001682:	01348d63          	beq	s1,s3,8000169c <reparent+0x4a>
    if(pp->parent == p){
    80001686:	7c9c                	ld	a5,56(s1)
    80001688:	ff279be3          	bne	a5,s2,8000167e <reparent+0x2c>
      pp->parent = initproc;
    8000168c:	000a3503          	ld	a0,0(s4)
    80001690:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001692:	00000097          	auipc	ra,0x0
    80001696:	f4a080e7          	jalr	-182(ra) # 800015dc <wakeup>
    8000169a:	b7d5                	j	8000167e <reparent+0x2c>
}
    8000169c:	70a2                	ld	ra,40(sp)
    8000169e:	7402                	ld	s0,32(sp)
    800016a0:	64e2                	ld	s1,24(sp)
    800016a2:	6942                	ld	s2,16(sp)
    800016a4:	69a2                	ld	s3,8(sp)
    800016a6:	6a02                	ld	s4,0(sp)
    800016a8:	6145                	addi	sp,sp,48
    800016aa:	8082                	ret

00000000800016ac <exit>:
{
    800016ac:	7179                	addi	sp,sp,-48
    800016ae:	f406                	sd	ra,40(sp)
    800016b0:	f022                	sd	s0,32(sp)
    800016b2:	ec26                	sd	s1,24(sp)
    800016b4:	e84a                	sd	s2,16(sp)
    800016b6:	e44e                	sd	s3,8(sp)
    800016b8:	e052                	sd	s4,0(sp)
    800016ba:	1800                	addi	s0,sp,48
    800016bc:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800016be:	fffff097          	auipc	ra,0xfffff
    800016c2:	79a080e7          	jalr	1946(ra) # 80000e58 <myproc>
    800016c6:	89aa                	mv	s3,a0
  if(p == initproc)
    800016c8:	00007797          	auipc	a5,0x7
    800016cc:	3587b783          	ld	a5,856(a5) # 80008a20 <initproc>
    800016d0:	0d050493          	addi	s1,a0,208
    800016d4:	15050913          	addi	s2,a0,336
    800016d8:	02a79363          	bne	a5,a0,800016fe <exit+0x52>
    panic("init exiting");
    800016dc:	00007517          	auipc	a0,0x7
    800016e0:	b0450513          	addi	a0,a0,-1276 # 800081e0 <etext+0x1e0>
    800016e4:	00004097          	auipc	ra,0x4
    800016e8:	5de080e7          	jalr	1502(ra) # 80005cc2 <panic>
      fileclose(f);
    800016ec:	00002097          	auipc	ra,0x2
    800016f0:	36a080e7          	jalr	874(ra) # 80003a56 <fileclose>
      p->ofile[fd] = 0;
    800016f4:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800016f8:	04a1                	addi	s1,s1,8
    800016fa:	01248563          	beq	s1,s2,80001704 <exit+0x58>
    if(p->ofile[fd]){
    800016fe:	6088                	ld	a0,0(s1)
    80001700:	f575                	bnez	a0,800016ec <exit+0x40>
    80001702:	bfdd                	j	800016f8 <exit+0x4c>
  begin_op();
    80001704:	00002097          	auipc	ra,0x2
    80001708:	e86080e7          	jalr	-378(ra) # 8000358a <begin_op>
  iput(p->cwd);
    8000170c:	1509b503          	ld	a0,336(s3)
    80001710:	00001097          	auipc	ra,0x1
    80001714:	672080e7          	jalr	1650(ra) # 80002d82 <iput>
  end_op();
    80001718:	00002097          	auipc	ra,0x2
    8000171c:	ef2080e7          	jalr	-270(ra) # 8000360a <end_op>
  p->cwd = 0;
    80001720:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001724:	00007497          	auipc	s1,0x7
    80001728:	35448493          	addi	s1,s1,852 # 80008a78 <wait_lock>
    8000172c:	8526                	mv	a0,s1
    8000172e:	00005097          	auipc	ra,0x5
    80001732:	ade080e7          	jalr	-1314(ra) # 8000620c <acquire>
  reparent(p);
    80001736:	854e                	mv	a0,s3
    80001738:	00000097          	auipc	ra,0x0
    8000173c:	f1a080e7          	jalr	-230(ra) # 80001652 <reparent>
  wakeup(p->parent);
    80001740:	0389b503          	ld	a0,56(s3)
    80001744:	00000097          	auipc	ra,0x0
    80001748:	e98080e7          	jalr	-360(ra) # 800015dc <wakeup>
  acquire(&p->lock);
    8000174c:	854e                	mv	a0,s3
    8000174e:	00005097          	auipc	ra,0x5
    80001752:	abe080e7          	jalr	-1346(ra) # 8000620c <acquire>
  p->xstate = status;
    80001756:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000175a:	4795                	li	a5,5
    8000175c:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001760:	8526                	mv	a0,s1
    80001762:	00005097          	auipc	ra,0x5
    80001766:	b5e080e7          	jalr	-1186(ra) # 800062c0 <release>
  sched();
    8000176a:	00000097          	auipc	ra,0x0
    8000176e:	cfc080e7          	jalr	-772(ra) # 80001466 <sched>
  panic("zombie exit");
    80001772:	00007517          	auipc	a0,0x7
    80001776:	a7e50513          	addi	a0,a0,-1410 # 800081f0 <etext+0x1f0>
    8000177a:	00004097          	auipc	ra,0x4
    8000177e:	548080e7          	jalr	1352(ra) # 80005cc2 <panic>

0000000080001782 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001782:	7179                	addi	sp,sp,-48
    80001784:	f406                	sd	ra,40(sp)
    80001786:	f022                	sd	s0,32(sp)
    80001788:	ec26                	sd	s1,24(sp)
    8000178a:	e84a                	sd	s2,16(sp)
    8000178c:	e44e                	sd	s3,8(sp)
    8000178e:	1800                	addi	s0,sp,48
    80001790:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001792:	00007497          	auipc	s1,0x7
    80001796:	6fe48493          	addi	s1,s1,1790 # 80008e90 <proc>
    8000179a:	0000d997          	auipc	s3,0xd
    8000179e:	0f698993          	addi	s3,s3,246 # 8000e890 <tickslock>
    acquire(&p->lock);
    800017a2:	8526                	mv	a0,s1
    800017a4:	00005097          	auipc	ra,0x5
    800017a8:	a68080e7          	jalr	-1432(ra) # 8000620c <acquire>
    if(p->pid == pid){
    800017ac:	589c                	lw	a5,48(s1)
    800017ae:	01278d63          	beq	a5,s2,800017c8 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800017b2:	8526                	mv	a0,s1
    800017b4:	00005097          	auipc	ra,0x5
    800017b8:	b0c080e7          	jalr	-1268(ra) # 800062c0 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800017bc:	16848493          	addi	s1,s1,360
    800017c0:	ff3491e3          	bne	s1,s3,800017a2 <kill+0x20>
  }
  return -1;
    800017c4:	557d                	li	a0,-1
    800017c6:	a829                	j	800017e0 <kill+0x5e>
      p->killed = 1;
    800017c8:	4785                	li	a5,1
    800017ca:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800017cc:	4c98                	lw	a4,24(s1)
    800017ce:	4789                	li	a5,2
    800017d0:	00f70f63          	beq	a4,a5,800017ee <kill+0x6c>
      release(&p->lock);
    800017d4:	8526                	mv	a0,s1
    800017d6:	00005097          	auipc	ra,0x5
    800017da:	aea080e7          	jalr	-1302(ra) # 800062c0 <release>
      return 0;
    800017de:	4501                	li	a0,0
}
    800017e0:	70a2                	ld	ra,40(sp)
    800017e2:	7402                	ld	s0,32(sp)
    800017e4:	64e2                	ld	s1,24(sp)
    800017e6:	6942                	ld	s2,16(sp)
    800017e8:	69a2                	ld	s3,8(sp)
    800017ea:	6145                	addi	sp,sp,48
    800017ec:	8082                	ret
        p->state = RUNNABLE;
    800017ee:	478d                	li	a5,3
    800017f0:	cc9c                	sw	a5,24(s1)
    800017f2:	b7cd                	j	800017d4 <kill+0x52>

00000000800017f4 <setkilled>:

void
setkilled(struct proc *p)
{
    800017f4:	1101                	addi	sp,sp,-32
    800017f6:	ec06                	sd	ra,24(sp)
    800017f8:	e822                	sd	s0,16(sp)
    800017fa:	e426                	sd	s1,8(sp)
    800017fc:	1000                	addi	s0,sp,32
    800017fe:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001800:	00005097          	auipc	ra,0x5
    80001804:	a0c080e7          	jalr	-1524(ra) # 8000620c <acquire>
  p->killed = 1;
    80001808:	4785                	li	a5,1
    8000180a:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000180c:	8526                	mv	a0,s1
    8000180e:	00005097          	auipc	ra,0x5
    80001812:	ab2080e7          	jalr	-1358(ra) # 800062c0 <release>
}
    80001816:	60e2                	ld	ra,24(sp)
    80001818:	6442                	ld	s0,16(sp)
    8000181a:	64a2                	ld	s1,8(sp)
    8000181c:	6105                	addi	sp,sp,32
    8000181e:	8082                	ret

0000000080001820 <killed>:

int
killed(struct proc *p)
{
    80001820:	1101                	addi	sp,sp,-32
    80001822:	ec06                	sd	ra,24(sp)
    80001824:	e822                	sd	s0,16(sp)
    80001826:	e426                	sd	s1,8(sp)
    80001828:	e04a                	sd	s2,0(sp)
    8000182a:	1000                	addi	s0,sp,32
    8000182c:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000182e:	00005097          	auipc	ra,0x5
    80001832:	9de080e7          	jalr	-1570(ra) # 8000620c <acquire>
  k = p->killed;
    80001836:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000183a:	8526                	mv	a0,s1
    8000183c:	00005097          	auipc	ra,0x5
    80001840:	a84080e7          	jalr	-1404(ra) # 800062c0 <release>
  return k;
}
    80001844:	854a                	mv	a0,s2
    80001846:	60e2                	ld	ra,24(sp)
    80001848:	6442                	ld	s0,16(sp)
    8000184a:	64a2                	ld	s1,8(sp)
    8000184c:	6902                	ld	s2,0(sp)
    8000184e:	6105                	addi	sp,sp,32
    80001850:	8082                	ret

0000000080001852 <wait>:
{
    80001852:	715d                	addi	sp,sp,-80
    80001854:	e486                	sd	ra,72(sp)
    80001856:	e0a2                	sd	s0,64(sp)
    80001858:	fc26                	sd	s1,56(sp)
    8000185a:	f84a                	sd	s2,48(sp)
    8000185c:	f44e                	sd	s3,40(sp)
    8000185e:	f052                	sd	s4,32(sp)
    80001860:	ec56                	sd	s5,24(sp)
    80001862:	e85a                	sd	s6,16(sp)
    80001864:	e45e                	sd	s7,8(sp)
    80001866:	e062                	sd	s8,0(sp)
    80001868:	0880                	addi	s0,sp,80
    8000186a:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000186c:	fffff097          	auipc	ra,0xfffff
    80001870:	5ec080e7          	jalr	1516(ra) # 80000e58 <myproc>
    80001874:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001876:	00007517          	auipc	a0,0x7
    8000187a:	20250513          	addi	a0,a0,514 # 80008a78 <wait_lock>
    8000187e:	00005097          	auipc	ra,0x5
    80001882:	98e080e7          	jalr	-1650(ra) # 8000620c <acquire>
    havekids = 0;
    80001886:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001888:	4a15                	li	s4,5
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000188a:	0000d997          	auipc	s3,0xd
    8000188e:	00698993          	addi	s3,s3,6 # 8000e890 <tickslock>
        havekids = 1;
    80001892:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001894:	00007c17          	auipc	s8,0x7
    80001898:	1e4c0c13          	addi	s8,s8,484 # 80008a78 <wait_lock>
    havekids = 0;
    8000189c:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000189e:	00007497          	auipc	s1,0x7
    800018a2:	5f248493          	addi	s1,s1,1522 # 80008e90 <proc>
    800018a6:	a0bd                	j	80001914 <wait+0xc2>
          pid = pp->pid;
    800018a8:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800018ac:	000b0e63          	beqz	s6,800018c8 <wait+0x76>
    800018b0:	4691                	li	a3,4
    800018b2:	02c48613          	addi	a2,s1,44
    800018b6:	85da                	mv	a1,s6
    800018b8:	05093503          	ld	a0,80(s2)
    800018bc:	fffff097          	auipc	ra,0xfffff
    800018c0:	25a080e7          	jalr	602(ra) # 80000b16 <copyout>
    800018c4:	02054563          	bltz	a0,800018ee <wait+0x9c>
          freeproc(pp);
    800018c8:	8526                	mv	a0,s1
    800018ca:	fffff097          	auipc	ra,0xfffff
    800018ce:	740080e7          	jalr	1856(ra) # 8000100a <freeproc>
          release(&pp->lock);
    800018d2:	8526                	mv	a0,s1
    800018d4:	00005097          	auipc	ra,0x5
    800018d8:	9ec080e7          	jalr	-1556(ra) # 800062c0 <release>
          release(&wait_lock);
    800018dc:	00007517          	auipc	a0,0x7
    800018e0:	19c50513          	addi	a0,a0,412 # 80008a78 <wait_lock>
    800018e4:	00005097          	auipc	ra,0x5
    800018e8:	9dc080e7          	jalr	-1572(ra) # 800062c0 <release>
          return pid;
    800018ec:	a0b5                	j	80001958 <wait+0x106>
            release(&pp->lock);
    800018ee:	8526                	mv	a0,s1
    800018f0:	00005097          	auipc	ra,0x5
    800018f4:	9d0080e7          	jalr	-1584(ra) # 800062c0 <release>
            release(&wait_lock);
    800018f8:	00007517          	auipc	a0,0x7
    800018fc:	18050513          	addi	a0,a0,384 # 80008a78 <wait_lock>
    80001900:	00005097          	auipc	ra,0x5
    80001904:	9c0080e7          	jalr	-1600(ra) # 800062c0 <release>
            return -1;
    80001908:	59fd                	li	s3,-1
    8000190a:	a0b9                	j	80001958 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000190c:	16848493          	addi	s1,s1,360
    80001910:	03348463          	beq	s1,s3,80001938 <wait+0xe6>
      if(pp->parent == p){
    80001914:	7c9c                	ld	a5,56(s1)
    80001916:	ff279be3          	bne	a5,s2,8000190c <wait+0xba>
        acquire(&pp->lock);
    8000191a:	8526                	mv	a0,s1
    8000191c:	00005097          	auipc	ra,0x5
    80001920:	8f0080e7          	jalr	-1808(ra) # 8000620c <acquire>
        if(pp->state == ZOMBIE){
    80001924:	4c9c                	lw	a5,24(s1)
    80001926:	f94781e3          	beq	a5,s4,800018a8 <wait+0x56>
        release(&pp->lock);
    8000192a:	8526                	mv	a0,s1
    8000192c:	00005097          	auipc	ra,0x5
    80001930:	994080e7          	jalr	-1644(ra) # 800062c0 <release>
        havekids = 1;
    80001934:	8756                	mv	a4,s5
    80001936:	bfd9                	j	8000190c <wait+0xba>
    if(!havekids || killed(p)){
    80001938:	c719                	beqz	a4,80001946 <wait+0xf4>
    8000193a:	854a                	mv	a0,s2
    8000193c:	00000097          	auipc	ra,0x0
    80001940:	ee4080e7          	jalr	-284(ra) # 80001820 <killed>
    80001944:	c51d                	beqz	a0,80001972 <wait+0x120>
      release(&wait_lock);
    80001946:	00007517          	auipc	a0,0x7
    8000194a:	13250513          	addi	a0,a0,306 # 80008a78 <wait_lock>
    8000194e:	00005097          	auipc	ra,0x5
    80001952:	972080e7          	jalr	-1678(ra) # 800062c0 <release>
      return -1;
    80001956:	59fd                	li	s3,-1
}
    80001958:	854e                	mv	a0,s3
    8000195a:	60a6                	ld	ra,72(sp)
    8000195c:	6406                	ld	s0,64(sp)
    8000195e:	74e2                	ld	s1,56(sp)
    80001960:	7942                	ld	s2,48(sp)
    80001962:	79a2                	ld	s3,40(sp)
    80001964:	7a02                	ld	s4,32(sp)
    80001966:	6ae2                	ld	s5,24(sp)
    80001968:	6b42                	ld	s6,16(sp)
    8000196a:	6ba2                	ld	s7,8(sp)
    8000196c:	6c02                	ld	s8,0(sp)
    8000196e:	6161                	addi	sp,sp,80
    80001970:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001972:	85e2                	mv	a1,s8
    80001974:	854a                	mv	a0,s2
    80001976:	00000097          	auipc	ra,0x0
    8000197a:	c02080e7          	jalr	-1022(ra) # 80001578 <sleep>
    havekids = 0;
    8000197e:	bf39                	j	8000189c <wait+0x4a>

0000000080001980 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001980:	7179                	addi	sp,sp,-48
    80001982:	f406                	sd	ra,40(sp)
    80001984:	f022                	sd	s0,32(sp)
    80001986:	ec26                	sd	s1,24(sp)
    80001988:	e84a                	sd	s2,16(sp)
    8000198a:	e44e                	sd	s3,8(sp)
    8000198c:	e052                	sd	s4,0(sp)
    8000198e:	1800                	addi	s0,sp,48
    80001990:	84aa                	mv	s1,a0
    80001992:	892e                	mv	s2,a1
    80001994:	89b2                	mv	s3,a2
    80001996:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001998:	fffff097          	auipc	ra,0xfffff
    8000199c:	4c0080e7          	jalr	1216(ra) # 80000e58 <myproc>
  if(user_dst){
    800019a0:	c08d                	beqz	s1,800019c2 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800019a2:	86d2                	mv	a3,s4
    800019a4:	864e                	mv	a2,s3
    800019a6:	85ca                	mv	a1,s2
    800019a8:	6928                	ld	a0,80(a0)
    800019aa:	fffff097          	auipc	ra,0xfffff
    800019ae:	16c080e7          	jalr	364(ra) # 80000b16 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800019b2:	70a2                	ld	ra,40(sp)
    800019b4:	7402                	ld	s0,32(sp)
    800019b6:	64e2                	ld	s1,24(sp)
    800019b8:	6942                	ld	s2,16(sp)
    800019ba:	69a2                	ld	s3,8(sp)
    800019bc:	6a02                	ld	s4,0(sp)
    800019be:	6145                	addi	sp,sp,48
    800019c0:	8082                	ret
    memmove((char *)dst, src, len);
    800019c2:	000a061b          	sext.w	a2,s4
    800019c6:	85ce                	mv	a1,s3
    800019c8:	854a                	mv	a0,s2
    800019ca:	fffff097          	auipc	ra,0xfffff
    800019ce:	80e080e7          	jalr	-2034(ra) # 800001d8 <memmove>
    return 0;
    800019d2:	8526                	mv	a0,s1
    800019d4:	bff9                	j	800019b2 <either_copyout+0x32>

00000000800019d6 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800019d6:	7179                	addi	sp,sp,-48
    800019d8:	f406                	sd	ra,40(sp)
    800019da:	f022                	sd	s0,32(sp)
    800019dc:	ec26                	sd	s1,24(sp)
    800019de:	e84a                	sd	s2,16(sp)
    800019e0:	e44e                	sd	s3,8(sp)
    800019e2:	e052                	sd	s4,0(sp)
    800019e4:	1800                	addi	s0,sp,48
    800019e6:	892a                	mv	s2,a0
    800019e8:	84ae                	mv	s1,a1
    800019ea:	89b2                	mv	s3,a2
    800019ec:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019ee:	fffff097          	auipc	ra,0xfffff
    800019f2:	46a080e7          	jalr	1130(ra) # 80000e58 <myproc>
  if(user_src){
    800019f6:	c08d                	beqz	s1,80001a18 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800019f8:	86d2                	mv	a3,s4
    800019fa:	864e                	mv	a2,s3
    800019fc:	85ca                	mv	a1,s2
    800019fe:	6928                	ld	a0,80(a0)
    80001a00:	fffff097          	auipc	ra,0xfffff
    80001a04:	1a2080e7          	jalr	418(ra) # 80000ba2 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a08:	70a2                	ld	ra,40(sp)
    80001a0a:	7402                	ld	s0,32(sp)
    80001a0c:	64e2                	ld	s1,24(sp)
    80001a0e:	6942                	ld	s2,16(sp)
    80001a10:	69a2                	ld	s3,8(sp)
    80001a12:	6a02                	ld	s4,0(sp)
    80001a14:	6145                	addi	sp,sp,48
    80001a16:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a18:	000a061b          	sext.w	a2,s4
    80001a1c:	85ce                	mv	a1,s3
    80001a1e:	854a                	mv	a0,s2
    80001a20:	ffffe097          	auipc	ra,0xffffe
    80001a24:	7b8080e7          	jalr	1976(ra) # 800001d8 <memmove>
    return 0;
    80001a28:	8526                	mv	a0,s1
    80001a2a:	bff9                	j	80001a08 <either_copyin+0x32>

0000000080001a2c <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a2c:	715d                	addi	sp,sp,-80
    80001a2e:	e486                	sd	ra,72(sp)
    80001a30:	e0a2                	sd	s0,64(sp)
    80001a32:	fc26                	sd	s1,56(sp)
    80001a34:	f84a                	sd	s2,48(sp)
    80001a36:	f44e                	sd	s3,40(sp)
    80001a38:	f052                	sd	s4,32(sp)
    80001a3a:	ec56                	sd	s5,24(sp)
    80001a3c:	e85a                	sd	s6,16(sp)
    80001a3e:	e45e                	sd	s7,8(sp)
    80001a40:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a42:	00006517          	auipc	a0,0x6
    80001a46:	60650513          	addi	a0,a0,1542 # 80008048 <etext+0x48>
    80001a4a:	00004097          	auipc	ra,0x4
    80001a4e:	2c2080e7          	jalr	706(ra) # 80005d0c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a52:	00007497          	auipc	s1,0x7
    80001a56:	59648493          	addi	s1,s1,1430 # 80008fe8 <proc+0x158>
    80001a5a:	0000d917          	auipc	s2,0xd
    80001a5e:	f8e90913          	addi	s2,s2,-114 # 8000e9e8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a62:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a64:	00006997          	auipc	s3,0x6
    80001a68:	79c98993          	addi	s3,s3,1948 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001a6c:	00006a97          	auipc	s5,0x6
    80001a70:	79ca8a93          	addi	s5,s5,1948 # 80008208 <etext+0x208>
    printf("\n");
    80001a74:	00006a17          	auipc	s4,0x6
    80001a78:	5d4a0a13          	addi	s4,s4,1492 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a7c:	00006b97          	auipc	s7,0x6
    80001a80:	7ccb8b93          	addi	s7,s7,1996 # 80008248 <states.1736>
    80001a84:	a00d                	j	80001aa6 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a86:	ed86a583          	lw	a1,-296(a3)
    80001a8a:	8556                	mv	a0,s5
    80001a8c:	00004097          	auipc	ra,0x4
    80001a90:	280080e7          	jalr	640(ra) # 80005d0c <printf>
    printf("\n");
    80001a94:	8552                	mv	a0,s4
    80001a96:	00004097          	auipc	ra,0x4
    80001a9a:	276080e7          	jalr	630(ra) # 80005d0c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a9e:	16848493          	addi	s1,s1,360
    80001aa2:	03248163          	beq	s1,s2,80001ac4 <procdump+0x98>
    if(p->state == UNUSED)
    80001aa6:	86a6                	mv	a3,s1
    80001aa8:	ec04a783          	lw	a5,-320(s1)
    80001aac:	dbed                	beqz	a5,80001a9e <procdump+0x72>
      state = "???";
    80001aae:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ab0:	fcfb6be3          	bltu	s6,a5,80001a86 <procdump+0x5a>
    80001ab4:	1782                	slli	a5,a5,0x20
    80001ab6:	9381                	srli	a5,a5,0x20
    80001ab8:	078e                	slli	a5,a5,0x3
    80001aba:	97de                	add	a5,a5,s7
    80001abc:	6390                	ld	a2,0(a5)
    80001abe:	f661                	bnez	a2,80001a86 <procdump+0x5a>
      state = "???";
    80001ac0:	864e                	mv	a2,s3
    80001ac2:	b7d1                	j	80001a86 <procdump+0x5a>
  }
}
    80001ac4:	60a6                	ld	ra,72(sp)
    80001ac6:	6406                	ld	s0,64(sp)
    80001ac8:	74e2                	ld	s1,56(sp)
    80001aca:	7942                	ld	s2,48(sp)
    80001acc:	79a2                	ld	s3,40(sp)
    80001ace:	7a02                	ld	s4,32(sp)
    80001ad0:	6ae2                	ld	s5,24(sp)
    80001ad2:	6b42                	ld	s6,16(sp)
    80001ad4:	6ba2                	ld	s7,8(sp)
    80001ad6:	6161                	addi	sp,sp,80
    80001ad8:	8082                	ret

0000000080001ada <swtch>:
    80001ada:	00153023          	sd	ra,0(a0)
    80001ade:	00253423          	sd	sp,8(a0)
    80001ae2:	e900                	sd	s0,16(a0)
    80001ae4:	ed04                	sd	s1,24(a0)
    80001ae6:	03253023          	sd	s2,32(a0)
    80001aea:	03353423          	sd	s3,40(a0)
    80001aee:	03453823          	sd	s4,48(a0)
    80001af2:	03553c23          	sd	s5,56(a0)
    80001af6:	05653023          	sd	s6,64(a0)
    80001afa:	05753423          	sd	s7,72(a0)
    80001afe:	05853823          	sd	s8,80(a0)
    80001b02:	05953c23          	sd	s9,88(a0)
    80001b06:	07a53023          	sd	s10,96(a0)
    80001b0a:	07b53423          	sd	s11,104(a0)
    80001b0e:	0005b083          	ld	ra,0(a1)
    80001b12:	0085b103          	ld	sp,8(a1)
    80001b16:	6980                	ld	s0,16(a1)
    80001b18:	6d84                	ld	s1,24(a1)
    80001b1a:	0205b903          	ld	s2,32(a1)
    80001b1e:	0285b983          	ld	s3,40(a1)
    80001b22:	0305ba03          	ld	s4,48(a1)
    80001b26:	0385ba83          	ld	s5,56(a1)
    80001b2a:	0405bb03          	ld	s6,64(a1)
    80001b2e:	0485bb83          	ld	s7,72(a1)
    80001b32:	0505bc03          	ld	s8,80(a1)
    80001b36:	0585bc83          	ld	s9,88(a1)
    80001b3a:	0605bd03          	ld	s10,96(a1)
    80001b3e:	0685bd83          	ld	s11,104(a1)
    80001b42:	8082                	ret

0000000080001b44 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b44:	1141                	addi	sp,sp,-16
    80001b46:	e406                	sd	ra,8(sp)
    80001b48:	e022                	sd	s0,0(sp)
    80001b4a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b4c:	00006597          	auipc	a1,0x6
    80001b50:	72c58593          	addi	a1,a1,1836 # 80008278 <states.1736+0x30>
    80001b54:	0000d517          	auipc	a0,0xd
    80001b58:	d3c50513          	addi	a0,a0,-708 # 8000e890 <tickslock>
    80001b5c:	00004097          	auipc	ra,0x4
    80001b60:	620080e7          	jalr	1568(ra) # 8000617c <initlock>
}
    80001b64:	60a2                	ld	ra,8(sp)
    80001b66:	6402                	ld	s0,0(sp)
    80001b68:	0141                	addi	sp,sp,16
    80001b6a:	8082                	ret

0000000080001b6c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b6c:	1141                	addi	sp,sp,-16
    80001b6e:	e422                	sd	s0,8(sp)
    80001b70:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b72:	00003797          	auipc	a5,0x3
    80001b76:	51e78793          	addi	a5,a5,1310 # 80005090 <kernelvec>
    80001b7a:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b7e:	6422                	ld	s0,8(sp)
    80001b80:	0141                	addi	sp,sp,16
    80001b82:	8082                	ret

0000000080001b84 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b84:	1141                	addi	sp,sp,-16
    80001b86:	e406                	sd	ra,8(sp)
    80001b88:	e022                	sd	s0,0(sp)
    80001b8a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b8c:	fffff097          	auipc	ra,0xfffff
    80001b90:	2cc080e7          	jalr	716(ra) # 80000e58 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b94:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b98:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b9a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b9e:	00005617          	auipc	a2,0x5
    80001ba2:	46260613          	addi	a2,a2,1122 # 80007000 <_trampoline>
    80001ba6:	00005697          	auipc	a3,0x5
    80001baa:	45a68693          	addi	a3,a3,1114 # 80007000 <_trampoline>
    80001bae:	8e91                	sub	a3,a3,a2
    80001bb0:	040007b7          	lui	a5,0x4000
    80001bb4:	17fd                	addi	a5,a5,-1
    80001bb6:	07b2                	slli	a5,a5,0xc
    80001bb8:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bba:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001bbe:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001bc0:	180026f3          	csrr	a3,satp
    80001bc4:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001bc6:	6d38                	ld	a4,88(a0)
    80001bc8:	6134                	ld	a3,64(a0)
    80001bca:	6585                	lui	a1,0x1
    80001bcc:	96ae                	add	a3,a3,a1
    80001bce:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001bd0:	6d38                	ld	a4,88(a0)
    80001bd2:	00000697          	auipc	a3,0x0
    80001bd6:	13068693          	addi	a3,a3,304 # 80001d02 <usertrap>
    80001bda:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001bdc:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bde:	8692                	mv	a3,tp
    80001be0:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001be2:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001be6:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bea:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bee:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001bf2:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bf4:	6f18                	ld	a4,24(a4)
    80001bf6:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001bfa:	6928                	ld	a0,80(a0)
    80001bfc:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001bfe:	00005717          	auipc	a4,0x5
    80001c02:	49e70713          	addi	a4,a4,1182 # 8000709c <userret>
    80001c06:	8f11                	sub	a4,a4,a2
    80001c08:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001c0a:	577d                	li	a4,-1
    80001c0c:	177e                	slli	a4,a4,0x3f
    80001c0e:	8d59                	or	a0,a0,a4
    80001c10:	9782                	jalr	a5
}
    80001c12:	60a2                	ld	ra,8(sp)
    80001c14:	6402                	ld	s0,0(sp)
    80001c16:	0141                	addi	sp,sp,16
    80001c18:	8082                	ret

0000000080001c1a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c1a:	1101                	addi	sp,sp,-32
    80001c1c:	ec06                	sd	ra,24(sp)
    80001c1e:	e822                	sd	s0,16(sp)
    80001c20:	e426                	sd	s1,8(sp)
    80001c22:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c24:	0000d497          	auipc	s1,0xd
    80001c28:	c6c48493          	addi	s1,s1,-916 # 8000e890 <tickslock>
    80001c2c:	8526                	mv	a0,s1
    80001c2e:	00004097          	auipc	ra,0x4
    80001c32:	5de080e7          	jalr	1502(ra) # 8000620c <acquire>
  ticks++;
    80001c36:	00007517          	auipc	a0,0x7
    80001c3a:	df250513          	addi	a0,a0,-526 # 80008a28 <ticks>
    80001c3e:	411c                	lw	a5,0(a0)
    80001c40:	2785                	addiw	a5,a5,1
    80001c42:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c44:	00000097          	auipc	ra,0x0
    80001c48:	998080e7          	jalr	-1640(ra) # 800015dc <wakeup>
  release(&tickslock);
    80001c4c:	8526                	mv	a0,s1
    80001c4e:	00004097          	auipc	ra,0x4
    80001c52:	672080e7          	jalr	1650(ra) # 800062c0 <release>
}
    80001c56:	60e2                	ld	ra,24(sp)
    80001c58:	6442                	ld	s0,16(sp)
    80001c5a:	64a2                	ld	s1,8(sp)
    80001c5c:	6105                	addi	sp,sp,32
    80001c5e:	8082                	ret

0000000080001c60 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c60:	1101                	addi	sp,sp,-32
    80001c62:	ec06                	sd	ra,24(sp)
    80001c64:	e822                	sd	s0,16(sp)
    80001c66:	e426                	sd	s1,8(sp)
    80001c68:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c6a:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001c6e:	00074d63          	bltz	a4,80001c88 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c72:	57fd                	li	a5,-1
    80001c74:	17fe                	slli	a5,a5,0x3f
    80001c76:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c78:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c7a:	06f70363          	beq	a4,a5,80001ce0 <devintr+0x80>
  }
}
    80001c7e:	60e2                	ld	ra,24(sp)
    80001c80:	6442                	ld	s0,16(sp)
    80001c82:	64a2                	ld	s1,8(sp)
    80001c84:	6105                	addi	sp,sp,32
    80001c86:	8082                	ret
     (scause & 0xff) == 9){
    80001c88:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001c8c:	46a5                	li	a3,9
    80001c8e:	fed792e3          	bne	a5,a3,80001c72 <devintr+0x12>
    int irq = plic_claim();
    80001c92:	00003097          	auipc	ra,0x3
    80001c96:	506080e7          	jalr	1286(ra) # 80005198 <plic_claim>
    80001c9a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c9c:	47a9                	li	a5,10
    80001c9e:	02f50763          	beq	a0,a5,80001ccc <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001ca2:	4785                	li	a5,1
    80001ca4:	02f50963          	beq	a0,a5,80001cd6 <devintr+0x76>
    return 1;
    80001ca8:	4505                	li	a0,1
    } else if(irq){
    80001caa:	d8f1                	beqz	s1,80001c7e <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001cac:	85a6                	mv	a1,s1
    80001cae:	00006517          	auipc	a0,0x6
    80001cb2:	5d250513          	addi	a0,a0,1490 # 80008280 <states.1736+0x38>
    80001cb6:	00004097          	auipc	ra,0x4
    80001cba:	056080e7          	jalr	86(ra) # 80005d0c <printf>
      plic_complete(irq);
    80001cbe:	8526                	mv	a0,s1
    80001cc0:	00003097          	auipc	ra,0x3
    80001cc4:	4fc080e7          	jalr	1276(ra) # 800051bc <plic_complete>
    return 1;
    80001cc8:	4505                	li	a0,1
    80001cca:	bf55                	j	80001c7e <devintr+0x1e>
      uartintr();
    80001ccc:	00004097          	auipc	ra,0x4
    80001cd0:	460080e7          	jalr	1120(ra) # 8000612c <uartintr>
    80001cd4:	b7ed                	j	80001cbe <devintr+0x5e>
      virtio_disk_intr();
    80001cd6:	00004097          	auipc	ra,0x4
    80001cda:	a10080e7          	jalr	-1520(ra) # 800056e6 <virtio_disk_intr>
    80001cde:	b7c5                	j	80001cbe <devintr+0x5e>
    if(cpuid() == 0){
    80001ce0:	fffff097          	auipc	ra,0xfffff
    80001ce4:	14c080e7          	jalr	332(ra) # 80000e2c <cpuid>
    80001ce8:	c901                	beqz	a0,80001cf8 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001cea:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cee:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cf0:	14479073          	csrw	sip,a5
    return 2;
    80001cf4:	4509                	li	a0,2
    80001cf6:	b761                	j	80001c7e <devintr+0x1e>
      clockintr();
    80001cf8:	00000097          	auipc	ra,0x0
    80001cfc:	f22080e7          	jalr	-222(ra) # 80001c1a <clockintr>
    80001d00:	b7ed                	j	80001cea <devintr+0x8a>

0000000080001d02 <usertrap>:
{
    80001d02:	1101                	addi	sp,sp,-32
    80001d04:	ec06                	sd	ra,24(sp)
    80001d06:	e822                	sd	s0,16(sp)
    80001d08:	e426                	sd	s1,8(sp)
    80001d0a:	e04a                	sd	s2,0(sp)
    80001d0c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d0e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d12:	1007f793          	andi	a5,a5,256
    80001d16:	e3b1                	bnez	a5,80001d5a <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d18:	00003797          	auipc	a5,0x3
    80001d1c:	37878793          	addi	a5,a5,888 # 80005090 <kernelvec>
    80001d20:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d24:	fffff097          	auipc	ra,0xfffff
    80001d28:	134080e7          	jalr	308(ra) # 80000e58 <myproc>
    80001d2c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d2e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d30:	14102773          	csrr	a4,sepc
    80001d34:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d36:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d3a:	47a1                	li	a5,8
    80001d3c:	02f70763          	beq	a4,a5,80001d6a <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001d40:	00000097          	auipc	ra,0x0
    80001d44:	f20080e7          	jalr	-224(ra) # 80001c60 <devintr>
    80001d48:	892a                	mv	s2,a0
    80001d4a:	c151                	beqz	a0,80001dce <usertrap+0xcc>
  if(killed(p))
    80001d4c:	8526                	mv	a0,s1
    80001d4e:	00000097          	auipc	ra,0x0
    80001d52:	ad2080e7          	jalr	-1326(ra) # 80001820 <killed>
    80001d56:	c929                	beqz	a0,80001da8 <usertrap+0xa6>
    80001d58:	a099                	j	80001d9e <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001d5a:	00006517          	auipc	a0,0x6
    80001d5e:	54650513          	addi	a0,a0,1350 # 800082a0 <states.1736+0x58>
    80001d62:	00004097          	auipc	ra,0x4
    80001d66:	f60080e7          	jalr	-160(ra) # 80005cc2 <panic>
    if(killed(p))
    80001d6a:	00000097          	auipc	ra,0x0
    80001d6e:	ab6080e7          	jalr	-1354(ra) # 80001820 <killed>
    80001d72:	e921                	bnez	a0,80001dc2 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001d74:	6cb8                	ld	a4,88(s1)
    80001d76:	6f1c                	ld	a5,24(a4)
    80001d78:	0791                	addi	a5,a5,4
    80001d7a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d7c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d80:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d84:	10079073          	csrw	sstatus,a5
    syscall();
    80001d88:	00000097          	auipc	ra,0x0
    80001d8c:	2d4080e7          	jalr	724(ra) # 8000205c <syscall>
  if(killed(p))
    80001d90:	8526                	mv	a0,s1
    80001d92:	00000097          	auipc	ra,0x0
    80001d96:	a8e080e7          	jalr	-1394(ra) # 80001820 <killed>
    80001d9a:	c911                	beqz	a0,80001dae <usertrap+0xac>
    80001d9c:	4901                	li	s2,0
    exit(-1);
    80001d9e:	557d                	li	a0,-1
    80001da0:	00000097          	auipc	ra,0x0
    80001da4:	90c080e7          	jalr	-1780(ra) # 800016ac <exit>
  if(which_dev == 2)
    80001da8:	4789                	li	a5,2
    80001daa:	04f90f63          	beq	s2,a5,80001e08 <usertrap+0x106>
  usertrapret();
    80001dae:	00000097          	auipc	ra,0x0
    80001db2:	dd6080e7          	jalr	-554(ra) # 80001b84 <usertrapret>
}
    80001db6:	60e2                	ld	ra,24(sp)
    80001db8:	6442                	ld	s0,16(sp)
    80001dba:	64a2                	ld	s1,8(sp)
    80001dbc:	6902                	ld	s2,0(sp)
    80001dbe:	6105                	addi	sp,sp,32
    80001dc0:	8082                	ret
      exit(-1);
    80001dc2:	557d                	li	a0,-1
    80001dc4:	00000097          	auipc	ra,0x0
    80001dc8:	8e8080e7          	jalr	-1816(ra) # 800016ac <exit>
    80001dcc:	b765                	j	80001d74 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dce:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001dd2:	5890                	lw	a2,48(s1)
    80001dd4:	00006517          	auipc	a0,0x6
    80001dd8:	4ec50513          	addi	a0,a0,1260 # 800082c0 <states.1736+0x78>
    80001ddc:	00004097          	auipc	ra,0x4
    80001de0:	f30080e7          	jalr	-208(ra) # 80005d0c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001de4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001de8:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001dec:	00006517          	auipc	a0,0x6
    80001df0:	50450513          	addi	a0,a0,1284 # 800082f0 <states.1736+0xa8>
    80001df4:	00004097          	auipc	ra,0x4
    80001df8:	f18080e7          	jalr	-232(ra) # 80005d0c <printf>
    setkilled(p);
    80001dfc:	8526                	mv	a0,s1
    80001dfe:	00000097          	auipc	ra,0x0
    80001e02:	9f6080e7          	jalr	-1546(ra) # 800017f4 <setkilled>
    80001e06:	b769                	j	80001d90 <usertrap+0x8e>
    yield();
    80001e08:	fffff097          	auipc	ra,0xfffff
    80001e0c:	734080e7          	jalr	1844(ra) # 8000153c <yield>
    80001e10:	bf79                	j	80001dae <usertrap+0xac>

0000000080001e12 <kerneltrap>:
{
    80001e12:	7179                	addi	sp,sp,-48
    80001e14:	f406                	sd	ra,40(sp)
    80001e16:	f022                	sd	s0,32(sp)
    80001e18:	ec26                	sd	s1,24(sp)
    80001e1a:	e84a                	sd	s2,16(sp)
    80001e1c:	e44e                	sd	s3,8(sp)
    80001e1e:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e20:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e24:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e28:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e2c:	1004f793          	andi	a5,s1,256
    80001e30:	cb85                	beqz	a5,80001e60 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e32:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e36:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e38:	ef85                	bnez	a5,80001e70 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e3a:	00000097          	auipc	ra,0x0
    80001e3e:	e26080e7          	jalr	-474(ra) # 80001c60 <devintr>
    80001e42:	cd1d                	beqz	a0,80001e80 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e44:	4789                	li	a5,2
    80001e46:	06f50a63          	beq	a0,a5,80001eba <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e4a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e4e:	10049073          	csrw	sstatus,s1
}
    80001e52:	70a2                	ld	ra,40(sp)
    80001e54:	7402                	ld	s0,32(sp)
    80001e56:	64e2                	ld	s1,24(sp)
    80001e58:	6942                	ld	s2,16(sp)
    80001e5a:	69a2                	ld	s3,8(sp)
    80001e5c:	6145                	addi	sp,sp,48
    80001e5e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e60:	00006517          	auipc	a0,0x6
    80001e64:	4b050513          	addi	a0,a0,1200 # 80008310 <states.1736+0xc8>
    80001e68:	00004097          	auipc	ra,0x4
    80001e6c:	e5a080e7          	jalr	-422(ra) # 80005cc2 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e70:	00006517          	auipc	a0,0x6
    80001e74:	4c850513          	addi	a0,a0,1224 # 80008338 <states.1736+0xf0>
    80001e78:	00004097          	auipc	ra,0x4
    80001e7c:	e4a080e7          	jalr	-438(ra) # 80005cc2 <panic>
    printf("scause %p\n", scause);
    80001e80:	85ce                	mv	a1,s3
    80001e82:	00006517          	auipc	a0,0x6
    80001e86:	4d650513          	addi	a0,a0,1238 # 80008358 <states.1736+0x110>
    80001e8a:	00004097          	auipc	ra,0x4
    80001e8e:	e82080e7          	jalr	-382(ra) # 80005d0c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e92:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e96:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e9a:	00006517          	auipc	a0,0x6
    80001e9e:	4ce50513          	addi	a0,a0,1230 # 80008368 <states.1736+0x120>
    80001ea2:	00004097          	auipc	ra,0x4
    80001ea6:	e6a080e7          	jalr	-406(ra) # 80005d0c <printf>
    panic("kerneltrap");
    80001eaa:	00006517          	auipc	a0,0x6
    80001eae:	4d650513          	addi	a0,a0,1238 # 80008380 <states.1736+0x138>
    80001eb2:	00004097          	auipc	ra,0x4
    80001eb6:	e10080e7          	jalr	-496(ra) # 80005cc2 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001eba:	fffff097          	auipc	ra,0xfffff
    80001ebe:	f9e080e7          	jalr	-98(ra) # 80000e58 <myproc>
    80001ec2:	d541                	beqz	a0,80001e4a <kerneltrap+0x38>
    80001ec4:	fffff097          	auipc	ra,0xfffff
    80001ec8:	f94080e7          	jalr	-108(ra) # 80000e58 <myproc>
    80001ecc:	4d18                	lw	a4,24(a0)
    80001ece:	4791                	li	a5,4
    80001ed0:	f6f71de3          	bne	a4,a5,80001e4a <kerneltrap+0x38>
    yield();
    80001ed4:	fffff097          	auipc	ra,0xfffff
    80001ed8:	668080e7          	jalr	1640(ra) # 8000153c <yield>
    80001edc:	b7bd                	j	80001e4a <kerneltrap+0x38>

0000000080001ede <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ede:	1101                	addi	sp,sp,-32
    80001ee0:	ec06                	sd	ra,24(sp)
    80001ee2:	e822                	sd	s0,16(sp)
    80001ee4:	e426                	sd	s1,8(sp)
    80001ee6:	1000                	addi	s0,sp,32
    80001ee8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001eea:	fffff097          	auipc	ra,0xfffff
    80001eee:	f6e080e7          	jalr	-146(ra) # 80000e58 <myproc>
  switch (n) {
    80001ef2:	4795                	li	a5,5
    80001ef4:	0497e163          	bltu	a5,s1,80001f36 <argraw+0x58>
    80001ef8:	048a                	slli	s1,s1,0x2
    80001efa:	00006717          	auipc	a4,0x6
    80001efe:	57e70713          	addi	a4,a4,1406 # 80008478 <states.1736+0x230>
    80001f02:	94ba                	add	s1,s1,a4
    80001f04:	409c                	lw	a5,0(s1)
    80001f06:	97ba                	add	a5,a5,a4
    80001f08:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f0a:	6d3c                	ld	a5,88(a0)
    80001f0c:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f0e:	60e2                	ld	ra,24(sp)
    80001f10:	6442                	ld	s0,16(sp)
    80001f12:	64a2                	ld	s1,8(sp)
    80001f14:	6105                	addi	sp,sp,32
    80001f16:	8082                	ret
    return p->trapframe->a1;
    80001f18:	6d3c                	ld	a5,88(a0)
    80001f1a:	7fa8                	ld	a0,120(a5)
    80001f1c:	bfcd                	j	80001f0e <argraw+0x30>
    return p->trapframe->a2;
    80001f1e:	6d3c                	ld	a5,88(a0)
    80001f20:	63c8                	ld	a0,128(a5)
    80001f22:	b7f5                	j	80001f0e <argraw+0x30>
    return p->trapframe->a3;
    80001f24:	6d3c                	ld	a5,88(a0)
    80001f26:	67c8                	ld	a0,136(a5)
    80001f28:	b7dd                	j	80001f0e <argraw+0x30>
    return p->trapframe->a4;
    80001f2a:	6d3c                	ld	a5,88(a0)
    80001f2c:	6bc8                	ld	a0,144(a5)
    80001f2e:	b7c5                	j	80001f0e <argraw+0x30>
    return p->trapframe->a5;
    80001f30:	6d3c                	ld	a5,88(a0)
    80001f32:	6fc8                	ld	a0,152(a5)
    80001f34:	bfe9                	j	80001f0e <argraw+0x30>
  panic("argraw");
    80001f36:	00006517          	auipc	a0,0x6
    80001f3a:	45a50513          	addi	a0,a0,1114 # 80008390 <states.1736+0x148>
    80001f3e:	00004097          	auipc	ra,0x4
    80001f42:	d84080e7          	jalr	-636(ra) # 80005cc2 <panic>

0000000080001f46 <fetchaddr>:
{
    80001f46:	1101                	addi	sp,sp,-32
    80001f48:	ec06                	sd	ra,24(sp)
    80001f4a:	e822                	sd	s0,16(sp)
    80001f4c:	e426                	sd	s1,8(sp)
    80001f4e:	e04a                	sd	s2,0(sp)
    80001f50:	1000                	addi	s0,sp,32
    80001f52:	84aa                	mv	s1,a0
    80001f54:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f56:	fffff097          	auipc	ra,0xfffff
    80001f5a:	f02080e7          	jalr	-254(ra) # 80000e58 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001f5e:	653c                	ld	a5,72(a0)
    80001f60:	02f4f863          	bgeu	s1,a5,80001f90 <fetchaddr+0x4a>
    80001f64:	00848713          	addi	a4,s1,8
    80001f68:	02e7e663          	bltu	a5,a4,80001f94 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f6c:	46a1                	li	a3,8
    80001f6e:	8626                	mv	a2,s1
    80001f70:	85ca                	mv	a1,s2
    80001f72:	6928                	ld	a0,80(a0)
    80001f74:	fffff097          	auipc	ra,0xfffff
    80001f78:	c2e080e7          	jalr	-978(ra) # 80000ba2 <copyin>
    80001f7c:	00a03533          	snez	a0,a0
    80001f80:	40a00533          	neg	a0,a0
}
    80001f84:	60e2                	ld	ra,24(sp)
    80001f86:	6442                	ld	s0,16(sp)
    80001f88:	64a2                	ld	s1,8(sp)
    80001f8a:	6902                	ld	s2,0(sp)
    80001f8c:	6105                	addi	sp,sp,32
    80001f8e:	8082                	ret
    return -1;
    80001f90:	557d                	li	a0,-1
    80001f92:	bfcd                	j	80001f84 <fetchaddr+0x3e>
    80001f94:	557d                	li	a0,-1
    80001f96:	b7fd                	j	80001f84 <fetchaddr+0x3e>

0000000080001f98 <fetchstr>:
{
    80001f98:	7179                	addi	sp,sp,-48
    80001f9a:	f406                	sd	ra,40(sp)
    80001f9c:	f022                	sd	s0,32(sp)
    80001f9e:	ec26                	sd	s1,24(sp)
    80001fa0:	e84a                	sd	s2,16(sp)
    80001fa2:	e44e                	sd	s3,8(sp)
    80001fa4:	1800                	addi	s0,sp,48
    80001fa6:	892a                	mv	s2,a0
    80001fa8:	84ae                	mv	s1,a1
    80001faa:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001fac:	fffff097          	auipc	ra,0xfffff
    80001fb0:	eac080e7          	jalr	-340(ra) # 80000e58 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001fb4:	86ce                	mv	a3,s3
    80001fb6:	864a                	mv	a2,s2
    80001fb8:	85a6                	mv	a1,s1
    80001fba:	6928                	ld	a0,80(a0)
    80001fbc:	fffff097          	auipc	ra,0xfffff
    80001fc0:	c72080e7          	jalr	-910(ra) # 80000c2e <copyinstr>
    80001fc4:	00054e63          	bltz	a0,80001fe0 <fetchstr+0x48>
  return strlen(buf);
    80001fc8:	8526                	mv	a0,s1
    80001fca:	ffffe097          	auipc	ra,0xffffe
    80001fce:	332080e7          	jalr	818(ra) # 800002fc <strlen>
}
    80001fd2:	70a2                	ld	ra,40(sp)
    80001fd4:	7402                	ld	s0,32(sp)
    80001fd6:	64e2                	ld	s1,24(sp)
    80001fd8:	6942                	ld	s2,16(sp)
    80001fda:	69a2                	ld	s3,8(sp)
    80001fdc:	6145                	addi	sp,sp,48
    80001fde:	8082                	ret
    return -1;
    80001fe0:	557d                	li	a0,-1
    80001fe2:	bfc5                	j	80001fd2 <fetchstr+0x3a>

0000000080001fe4 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001fe4:	1101                	addi	sp,sp,-32
    80001fe6:	ec06                	sd	ra,24(sp)
    80001fe8:	e822                	sd	s0,16(sp)
    80001fea:	e426                	sd	s1,8(sp)
    80001fec:	1000                	addi	s0,sp,32
    80001fee:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001ff0:	00000097          	auipc	ra,0x0
    80001ff4:	eee080e7          	jalr	-274(ra) # 80001ede <argraw>
    80001ff8:	c088                	sw	a0,0(s1)
}
    80001ffa:	60e2                	ld	ra,24(sp)
    80001ffc:	6442                	ld	s0,16(sp)
    80001ffe:	64a2                	ld	s1,8(sp)
    80002000:	6105                	addi	sp,sp,32
    80002002:	8082                	ret

0000000080002004 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002004:	1101                	addi	sp,sp,-32
    80002006:	ec06                	sd	ra,24(sp)
    80002008:	e822                	sd	s0,16(sp)
    8000200a:	e426                	sd	s1,8(sp)
    8000200c:	1000                	addi	s0,sp,32
    8000200e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002010:	00000097          	auipc	ra,0x0
    80002014:	ece080e7          	jalr	-306(ra) # 80001ede <argraw>
    80002018:	e088                	sd	a0,0(s1)
}
    8000201a:	60e2                	ld	ra,24(sp)
    8000201c:	6442                	ld	s0,16(sp)
    8000201e:	64a2                	ld	s1,8(sp)
    80002020:	6105                	addi	sp,sp,32
    80002022:	8082                	ret

0000000080002024 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002024:	7179                	addi	sp,sp,-48
    80002026:	f406                	sd	ra,40(sp)
    80002028:	f022                	sd	s0,32(sp)
    8000202a:	ec26                	sd	s1,24(sp)
    8000202c:	e84a                	sd	s2,16(sp)
    8000202e:	1800                	addi	s0,sp,48
    80002030:	84ae                	mv	s1,a1
    80002032:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002034:	fd840593          	addi	a1,s0,-40
    80002038:	00000097          	auipc	ra,0x0
    8000203c:	fcc080e7          	jalr	-52(ra) # 80002004 <argaddr>
  return fetchstr(addr, buf, max);
    80002040:	864a                	mv	a2,s2
    80002042:	85a6                	mv	a1,s1
    80002044:	fd843503          	ld	a0,-40(s0)
    80002048:	00000097          	auipc	ra,0x0
    8000204c:	f50080e7          	jalr	-176(ra) # 80001f98 <fetchstr>
}
    80002050:	70a2                	ld	ra,40(sp)
    80002052:	7402                	ld	s0,32(sp)
    80002054:	64e2                	ld	s1,24(sp)
    80002056:	6942                	ld	s2,16(sp)
    80002058:	6145                	addi	sp,sp,48
    8000205a:	8082                	ret

000000008000205c <syscall>:



void
syscall(void)
{
    8000205c:	7179                	addi	sp,sp,-48
    8000205e:	f406                	sd	ra,40(sp)
    80002060:	f022                	sd	s0,32(sp)
    80002062:	ec26                	sd	s1,24(sp)
    80002064:	e84a                	sd	s2,16(sp)
    80002066:	e44e                	sd	s3,8(sp)
    80002068:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    8000206a:	fffff097          	auipc	ra,0xfffff
    8000206e:	dee080e7          	jalr	-530(ra) # 80000e58 <myproc>
    80002072:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002074:	6d3c                	ld	a5,88(a0)
    80002076:	77dc                	ld	a5,168(a5)
    80002078:	0007891b          	sext.w	s2,a5
  
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000207c:	37fd                	addiw	a5,a5,-1
    8000207e:	4755                	li	a4,21
    80002080:	04f76963          	bltu	a4,a5,800020d2 <syscall+0x76>
    80002084:	00391713          	slli	a4,s2,0x3
    80002088:	00006797          	auipc	a5,0x6
    8000208c:	40878793          	addi	a5,a5,1032 # 80008490 <syscalls>
    80002090:	97ba                	add	a5,a5,a4
    80002092:	639c                	ld	a5,0(a5)
    80002094:	cf9d                	beqz	a5,800020d2 <syscall+0x76>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    uint64 rv = syscalls[num]();
    80002096:	9782                	jalr	a5
    80002098:	89aa                	mv	s3,a0

    if (p->tracemask & (1 << num)) {
    8000209a:	58dc                	lw	a5,52(s1)
    8000209c:	4127d7bb          	sraw	a5,a5,s2
    800020a0:	8b85                	andi	a5,a5,1
    800020a2:	e789                	bnez	a5,800020ac <syscall+0x50>
      printf("%d: syscall %s -> %d\n", p->pid, syscallnames[num], rv);
    }

    p->trapframe->a0 = rv;
    800020a4:	6cbc                	ld	a5,88(s1)
    800020a6:	0737b823          	sd	s3,112(a5)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800020aa:	a099                	j	800020f0 <syscall+0x94>
      printf("%d: syscall %s -> %d\n", p->pid, syscallnames[num], rv);
    800020ac:	090e                	slli	s2,s2,0x3
    800020ae:	00006797          	auipc	a5,0x6
    800020b2:	3e278793          	addi	a5,a5,994 # 80008490 <syscalls>
    800020b6:	993e                	add	s2,s2,a5
    800020b8:	86aa                	mv	a3,a0
    800020ba:	0b893603          	ld	a2,184(s2)
    800020be:	588c                	lw	a1,48(s1)
    800020c0:	00006517          	auipc	a0,0x6
    800020c4:	2d850513          	addi	a0,a0,728 # 80008398 <states.1736+0x150>
    800020c8:	00004097          	auipc	ra,0x4
    800020cc:	c44080e7          	jalr	-956(ra) # 80005d0c <printf>
    800020d0:	bfd1                	j	800020a4 <syscall+0x48>
  } else {
    printf("%d %s: unknown sys call %d\n",p->pid, p->name, num);
    800020d2:	86ca                	mv	a3,s2
    800020d4:	15848613          	addi	a2,s1,344
    800020d8:	588c                	lw	a1,48(s1)
    800020da:	00006517          	auipc	a0,0x6
    800020de:	2d650513          	addi	a0,a0,726 # 800083b0 <states.1736+0x168>
    800020e2:	00004097          	auipc	ra,0x4
    800020e6:	c2a080e7          	jalr	-982(ra) # 80005d0c <printf>
    p->trapframe->a0 = -1;
    800020ea:	6cbc                	ld	a5,88(s1)
    800020ec:	577d                	li	a4,-1
    800020ee:	fbb8                	sd	a4,112(a5)
  }
}
    800020f0:	70a2                	ld	ra,40(sp)
    800020f2:	7402                	ld	s0,32(sp)
    800020f4:	64e2                	ld	s1,24(sp)
    800020f6:	6942                	ld	s2,16(sp)
    800020f8:	69a2                	ld	s3,8(sp)
    800020fa:	6145                	addi	sp,sp,48
    800020fc:	8082                	ret

00000000800020fe <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800020fe:	1101                	addi	sp,sp,-32
    80002100:	ec06                	sd	ra,24(sp)
    80002102:	e822                	sd	s0,16(sp)
    80002104:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002106:	fec40593          	addi	a1,s0,-20
    8000210a:	4501                	li	a0,0
    8000210c:	00000097          	auipc	ra,0x0
    80002110:	ed8080e7          	jalr	-296(ra) # 80001fe4 <argint>
  exit(n);
    80002114:	fec42503          	lw	a0,-20(s0)
    80002118:	fffff097          	auipc	ra,0xfffff
    8000211c:	594080e7          	jalr	1428(ra) # 800016ac <exit>
  return 0;  // not reached
}
    80002120:	4501                	li	a0,0
    80002122:	60e2                	ld	ra,24(sp)
    80002124:	6442                	ld	s0,16(sp)
    80002126:	6105                	addi	sp,sp,32
    80002128:	8082                	ret

000000008000212a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000212a:	1141                	addi	sp,sp,-16
    8000212c:	e406                	sd	ra,8(sp)
    8000212e:	e022                	sd	s0,0(sp)
    80002130:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002132:	fffff097          	auipc	ra,0xfffff
    80002136:	d26080e7          	jalr	-730(ra) # 80000e58 <myproc>
}
    8000213a:	5908                	lw	a0,48(a0)
    8000213c:	60a2                	ld	ra,8(sp)
    8000213e:	6402                	ld	s0,0(sp)
    80002140:	0141                	addi	sp,sp,16
    80002142:	8082                	ret

0000000080002144 <sys_fork>:

uint64
sys_fork(void)
{
    80002144:	1141                	addi	sp,sp,-16
    80002146:	e406                	sd	ra,8(sp)
    80002148:	e022                	sd	s0,0(sp)
    8000214a:	0800                	addi	s0,sp,16
  return fork();
    8000214c:	fffff097          	auipc	ra,0xfffff
    80002150:	0c2080e7          	jalr	194(ra) # 8000120e <fork>
}
    80002154:	60a2                	ld	ra,8(sp)
    80002156:	6402                	ld	s0,0(sp)
    80002158:	0141                	addi	sp,sp,16
    8000215a:	8082                	ret

000000008000215c <sys_wait>:

uint64
sys_wait(void)
{
    8000215c:	1101                	addi	sp,sp,-32
    8000215e:	ec06                	sd	ra,24(sp)
    80002160:	e822                	sd	s0,16(sp)
    80002162:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002164:	fe840593          	addi	a1,s0,-24
    80002168:	4501                	li	a0,0
    8000216a:	00000097          	auipc	ra,0x0
    8000216e:	e9a080e7          	jalr	-358(ra) # 80002004 <argaddr>
  return wait(p);
    80002172:	fe843503          	ld	a0,-24(s0)
    80002176:	fffff097          	auipc	ra,0xfffff
    8000217a:	6dc080e7          	jalr	1756(ra) # 80001852 <wait>
}
    8000217e:	60e2                	ld	ra,24(sp)
    80002180:	6442                	ld	s0,16(sp)
    80002182:	6105                	addi	sp,sp,32
    80002184:	8082                	ret

0000000080002186 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002186:	7179                	addi	sp,sp,-48
    80002188:	f406                	sd	ra,40(sp)
    8000218a:	f022                	sd	s0,32(sp)
    8000218c:	ec26                	sd	s1,24(sp)
    8000218e:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002190:	fdc40593          	addi	a1,s0,-36
    80002194:	4501                	li	a0,0
    80002196:	00000097          	auipc	ra,0x0
    8000219a:	e4e080e7          	jalr	-434(ra) # 80001fe4 <argint>
  addr = myproc()->sz;
    8000219e:	fffff097          	auipc	ra,0xfffff
    800021a2:	cba080e7          	jalr	-838(ra) # 80000e58 <myproc>
    800021a6:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800021a8:	fdc42503          	lw	a0,-36(s0)
    800021ac:	fffff097          	auipc	ra,0xfffff
    800021b0:	006080e7          	jalr	6(ra) # 800011b2 <growproc>
    800021b4:	00054863          	bltz	a0,800021c4 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800021b8:	8526                	mv	a0,s1
    800021ba:	70a2                	ld	ra,40(sp)
    800021bc:	7402                	ld	s0,32(sp)
    800021be:	64e2                	ld	s1,24(sp)
    800021c0:	6145                	addi	sp,sp,48
    800021c2:	8082                	ret
    return -1;
    800021c4:	54fd                	li	s1,-1
    800021c6:	bfcd                	j	800021b8 <sys_sbrk+0x32>

00000000800021c8 <sys_sleep>:

uint64
sys_sleep(void)
{
    800021c8:	7139                	addi	sp,sp,-64
    800021ca:	fc06                	sd	ra,56(sp)
    800021cc:	f822                	sd	s0,48(sp)
    800021ce:	f426                	sd	s1,40(sp)
    800021d0:	f04a                	sd	s2,32(sp)
    800021d2:	ec4e                	sd	s3,24(sp)
    800021d4:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800021d6:	fcc40593          	addi	a1,s0,-52
    800021da:	4501                	li	a0,0
    800021dc:	00000097          	auipc	ra,0x0
    800021e0:	e08080e7          	jalr	-504(ra) # 80001fe4 <argint>
  if(n < 0)
    800021e4:	fcc42783          	lw	a5,-52(s0)
    800021e8:	0607cf63          	bltz	a5,80002266 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    800021ec:	0000c517          	auipc	a0,0xc
    800021f0:	6a450513          	addi	a0,a0,1700 # 8000e890 <tickslock>
    800021f4:	00004097          	auipc	ra,0x4
    800021f8:	018080e7          	jalr	24(ra) # 8000620c <acquire>
  ticks0 = ticks;
    800021fc:	00007917          	auipc	s2,0x7
    80002200:	82c92903          	lw	s2,-2004(s2) # 80008a28 <ticks>
  while(ticks - ticks0 < n){
    80002204:	fcc42783          	lw	a5,-52(s0)
    80002208:	cf9d                	beqz	a5,80002246 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000220a:	0000c997          	auipc	s3,0xc
    8000220e:	68698993          	addi	s3,s3,1670 # 8000e890 <tickslock>
    80002212:	00007497          	auipc	s1,0x7
    80002216:	81648493          	addi	s1,s1,-2026 # 80008a28 <ticks>
    if(killed(myproc())){
    8000221a:	fffff097          	auipc	ra,0xfffff
    8000221e:	c3e080e7          	jalr	-962(ra) # 80000e58 <myproc>
    80002222:	fffff097          	auipc	ra,0xfffff
    80002226:	5fe080e7          	jalr	1534(ra) # 80001820 <killed>
    8000222a:	e129                	bnez	a0,8000226c <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    8000222c:	85ce                	mv	a1,s3
    8000222e:	8526                	mv	a0,s1
    80002230:	fffff097          	auipc	ra,0xfffff
    80002234:	348080e7          	jalr	840(ra) # 80001578 <sleep>
  while(ticks - ticks0 < n){
    80002238:	409c                	lw	a5,0(s1)
    8000223a:	412787bb          	subw	a5,a5,s2
    8000223e:	fcc42703          	lw	a4,-52(s0)
    80002242:	fce7ece3          	bltu	a5,a4,8000221a <sys_sleep+0x52>
  }
  release(&tickslock);
    80002246:	0000c517          	auipc	a0,0xc
    8000224a:	64a50513          	addi	a0,a0,1610 # 8000e890 <tickslock>
    8000224e:	00004097          	auipc	ra,0x4
    80002252:	072080e7          	jalr	114(ra) # 800062c0 <release>
  return 0;
    80002256:	4501                	li	a0,0
}
    80002258:	70e2                	ld	ra,56(sp)
    8000225a:	7442                	ld	s0,48(sp)
    8000225c:	74a2                	ld	s1,40(sp)
    8000225e:	7902                	ld	s2,32(sp)
    80002260:	69e2                	ld	s3,24(sp)
    80002262:	6121                	addi	sp,sp,64
    80002264:	8082                	ret
    n = 0;
    80002266:	fc042623          	sw	zero,-52(s0)
    8000226a:	b749                	j	800021ec <sys_sleep+0x24>
      release(&tickslock);
    8000226c:	0000c517          	auipc	a0,0xc
    80002270:	62450513          	addi	a0,a0,1572 # 8000e890 <tickslock>
    80002274:	00004097          	auipc	ra,0x4
    80002278:	04c080e7          	jalr	76(ra) # 800062c0 <release>
      return -1;
    8000227c:	557d                	li	a0,-1
    8000227e:	bfe9                	j	80002258 <sys_sleep+0x90>

0000000080002280 <sys_kill>:

uint64
sys_kill(void)
{
    80002280:	1101                	addi	sp,sp,-32
    80002282:	ec06                	sd	ra,24(sp)
    80002284:	e822                	sd	s0,16(sp)
    80002286:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002288:	fec40593          	addi	a1,s0,-20
    8000228c:	4501                	li	a0,0
    8000228e:	00000097          	auipc	ra,0x0
    80002292:	d56080e7          	jalr	-682(ra) # 80001fe4 <argint>
  return kill(pid);
    80002296:	fec42503          	lw	a0,-20(s0)
    8000229a:	fffff097          	auipc	ra,0xfffff
    8000229e:	4e8080e7          	jalr	1256(ra) # 80001782 <kill>
}
    800022a2:	60e2                	ld	ra,24(sp)
    800022a4:	6442                	ld	s0,16(sp)
    800022a6:	6105                	addi	sp,sp,32
    800022a8:	8082                	ret

00000000800022aa <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800022aa:	1101                	addi	sp,sp,-32
    800022ac:	ec06                	sd	ra,24(sp)
    800022ae:	e822                	sd	s0,16(sp)
    800022b0:	e426                	sd	s1,8(sp)
    800022b2:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022b4:	0000c517          	auipc	a0,0xc
    800022b8:	5dc50513          	addi	a0,a0,1500 # 8000e890 <tickslock>
    800022bc:	00004097          	auipc	ra,0x4
    800022c0:	f50080e7          	jalr	-176(ra) # 8000620c <acquire>
  xticks = ticks;
    800022c4:	00006497          	auipc	s1,0x6
    800022c8:	7644a483          	lw	s1,1892(s1) # 80008a28 <ticks>
  release(&tickslock);
    800022cc:	0000c517          	auipc	a0,0xc
    800022d0:	5c450513          	addi	a0,a0,1476 # 8000e890 <tickslock>
    800022d4:	00004097          	auipc	ra,0x4
    800022d8:	fec080e7          	jalr	-20(ra) # 800062c0 <release>
  return xticks;
}
    800022dc:	02049513          	slli	a0,s1,0x20
    800022e0:	9101                	srli	a0,a0,0x20
    800022e2:	60e2                	ld	ra,24(sp)
    800022e4:	6442                	ld	s0,16(sp)
    800022e6:	64a2                	ld	s1,8(sp)
    800022e8:	6105                	addi	sp,sp,32
    800022ea:	8082                	ret

00000000800022ec <sys_trace>:

uint64
sys_trace(void)
{
    800022ec:	1101                	addi	sp,sp,-32
    800022ee:	ec06                	sd	ra,24(sp)
    800022f0:	e822                	sd	s0,16(sp)
    800022f2:	1000                	addi	s0,sp,32
  int mask;
  argint(0, &mask);
    800022f4:	fec40593          	addi	a1,s0,-20
    800022f8:	4501                	li	a0,0
    800022fa:	00000097          	auipc	ra,0x0
    800022fe:	cea080e7          	jalr	-790(ra) # 80001fe4 <argint>

  if (mask < 0) {
    80002302:	fec42783          	lw	a5,-20(s0)
    return -1;
    80002306:	557d                	li	a0,-1
  if (mask < 0) {
    80002308:	0007c863          	bltz	a5,80002318 <sys_trace+0x2c>
  }

  trace(mask);
    8000230c:	853e                	mv	a0,a5
    8000230e:	fffff097          	auipc	ra,0xfffff
    80002312:	098080e7          	jalr	152(ra) # 800013a6 <trace>

  return 0;
    80002316:	4501                	li	a0,0
}
    80002318:	60e2                	ld	ra,24(sp)
    8000231a:	6442                	ld	s0,16(sp)
    8000231c:	6105                	addi	sp,sp,32
    8000231e:	8082                	ret

0000000080002320 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002320:	7179                	addi	sp,sp,-48
    80002322:	f406                	sd	ra,40(sp)
    80002324:	f022                	sd	s0,32(sp)
    80002326:	ec26                	sd	s1,24(sp)
    80002328:	e84a                	sd	s2,16(sp)
    8000232a:	e44e                	sd	s3,8(sp)
    8000232c:	e052                	sd	s4,0(sp)
    8000232e:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002330:	00006597          	auipc	a1,0x6
    80002334:	2d058593          	addi	a1,a1,720 # 80008600 <syscallnames+0xb8>
    80002338:	0000c517          	auipc	a0,0xc
    8000233c:	57050513          	addi	a0,a0,1392 # 8000e8a8 <bcache>
    80002340:	00004097          	auipc	ra,0x4
    80002344:	e3c080e7          	jalr	-452(ra) # 8000617c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002348:	00014797          	auipc	a5,0x14
    8000234c:	56078793          	addi	a5,a5,1376 # 800168a8 <bcache+0x8000>
    80002350:	00014717          	auipc	a4,0x14
    80002354:	7c070713          	addi	a4,a4,1984 # 80016b10 <bcache+0x8268>
    80002358:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000235c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002360:	0000c497          	auipc	s1,0xc
    80002364:	56048493          	addi	s1,s1,1376 # 8000e8c0 <bcache+0x18>
    b->next = bcache.head.next;
    80002368:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000236a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000236c:	00006a17          	auipc	s4,0x6
    80002370:	29ca0a13          	addi	s4,s4,668 # 80008608 <syscallnames+0xc0>
    b->next = bcache.head.next;
    80002374:	2b893783          	ld	a5,696(s2)
    80002378:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000237a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000237e:	85d2                	mv	a1,s4
    80002380:	01048513          	addi	a0,s1,16
    80002384:	00001097          	auipc	ra,0x1
    80002388:	4c4080e7          	jalr	1220(ra) # 80003848 <initsleeplock>
    bcache.head.next->prev = b;
    8000238c:	2b893783          	ld	a5,696(s2)
    80002390:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002392:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002396:	45848493          	addi	s1,s1,1112
    8000239a:	fd349de3          	bne	s1,s3,80002374 <binit+0x54>
  }
}
    8000239e:	70a2                	ld	ra,40(sp)
    800023a0:	7402                	ld	s0,32(sp)
    800023a2:	64e2                	ld	s1,24(sp)
    800023a4:	6942                	ld	s2,16(sp)
    800023a6:	69a2                	ld	s3,8(sp)
    800023a8:	6a02                	ld	s4,0(sp)
    800023aa:	6145                	addi	sp,sp,48
    800023ac:	8082                	ret

00000000800023ae <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023ae:	7179                	addi	sp,sp,-48
    800023b0:	f406                	sd	ra,40(sp)
    800023b2:	f022                	sd	s0,32(sp)
    800023b4:	ec26                	sd	s1,24(sp)
    800023b6:	e84a                	sd	s2,16(sp)
    800023b8:	e44e                	sd	s3,8(sp)
    800023ba:	1800                	addi	s0,sp,48
    800023bc:	89aa                	mv	s3,a0
    800023be:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800023c0:	0000c517          	auipc	a0,0xc
    800023c4:	4e850513          	addi	a0,a0,1256 # 8000e8a8 <bcache>
    800023c8:	00004097          	auipc	ra,0x4
    800023cc:	e44080e7          	jalr	-444(ra) # 8000620c <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800023d0:	00014497          	auipc	s1,0x14
    800023d4:	7904b483          	ld	s1,1936(s1) # 80016b60 <bcache+0x82b8>
    800023d8:	00014797          	auipc	a5,0x14
    800023dc:	73878793          	addi	a5,a5,1848 # 80016b10 <bcache+0x8268>
    800023e0:	02f48f63          	beq	s1,a5,8000241e <bread+0x70>
    800023e4:	873e                	mv	a4,a5
    800023e6:	a021                	j	800023ee <bread+0x40>
    800023e8:	68a4                	ld	s1,80(s1)
    800023ea:	02e48a63          	beq	s1,a4,8000241e <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800023ee:	449c                	lw	a5,8(s1)
    800023f0:	ff379ce3          	bne	a5,s3,800023e8 <bread+0x3a>
    800023f4:	44dc                	lw	a5,12(s1)
    800023f6:	ff2799e3          	bne	a5,s2,800023e8 <bread+0x3a>
      b->refcnt++;
    800023fa:	40bc                	lw	a5,64(s1)
    800023fc:	2785                	addiw	a5,a5,1
    800023fe:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002400:	0000c517          	auipc	a0,0xc
    80002404:	4a850513          	addi	a0,a0,1192 # 8000e8a8 <bcache>
    80002408:	00004097          	auipc	ra,0x4
    8000240c:	eb8080e7          	jalr	-328(ra) # 800062c0 <release>
      acquiresleep(&b->lock);
    80002410:	01048513          	addi	a0,s1,16
    80002414:	00001097          	auipc	ra,0x1
    80002418:	46e080e7          	jalr	1134(ra) # 80003882 <acquiresleep>
      return b;
    8000241c:	a8b9                	j	8000247a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000241e:	00014497          	auipc	s1,0x14
    80002422:	73a4b483          	ld	s1,1850(s1) # 80016b58 <bcache+0x82b0>
    80002426:	00014797          	auipc	a5,0x14
    8000242a:	6ea78793          	addi	a5,a5,1770 # 80016b10 <bcache+0x8268>
    8000242e:	00f48863          	beq	s1,a5,8000243e <bread+0x90>
    80002432:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002434:	40bc                	lw	a5,64(s1)
    80002436:	cf81                	beqz	a5,8000244e <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002438:	64a4                	ld	s1,72(s1)
    8000243a:	fee49de3          	bne	s1,a4,80002434 <bread+0x86>
  panic("bget: no buffers");
    8000243e:	00006517          	auipc	a0,0x6
    80002442:	1d250513          	addi	a0,a0,466 # 80008610 <syscallnames+0xc8>
    80002446:	00004097          	auipc	ra,0x4
    8000244a:	87c080e7          	jalr	-1924(ra) # 80005cc2 <panic>
      b->dev = dev;
    8000244e:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002452:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002456:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000245a:	4785                	li	a5,1
    8000245c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000245e:	0000c517          	auipc	a0,0xc
    80002462:	44a50513          	addi	a0,a0,1098 # 8000e8a8 <bcache>
    80002466:	00004097          	auipc	ra,0x4
    8000246a:	e5a080e7          	jalr	-422(ra) # 800062c0 <release>
      acquiresleep(&b->lock);
    8000246e:	01048513          	addi	a0,s1,16
    80002472:	00001097          	auipc	ra,0x1
    80002476:	410080e7          	jalr	1040(ra) # 80003882 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000247a:	409c                	lw	a5,0(s1)
    8000247c:	cb89                	beqz	a5,8000248e <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000247e:	8526                	mv	a0,s1
    80002480:	70a2                	ld	ra,40(sp)
    80002482:	7402                	ld	s0,32(sp)
    80002484:	64e2                	ld	s1,24(sp)
    80002486:	6942                	ld	s2,16(sp)
    80002488:	69a2                	ld	s3,8(sp)
    8000248a:	6145                	addi	sp,sp,48
    8000248c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000248e:	4581                	li	a1,0
    80002490:	8526                	mv	a0,s1
    80002492:	00003097          	auipc	ra,0x3
    80002496:	fc6080e7          	jalr	-58(ra) # 80005458 <virtio_disk_rw>
    b->valid = 1;
    8000249a:	4785                	li	a5,1
    8000249c:	c09c                	sw	a5,0(s1)
  return b;
    8000249e:	b7c5                	j	8000247e <bread+0xd0>

00000000800024a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024a0:	1101                	addi	sp,sp,-32
    800024a2:	ec06                	sd	ra,24(sp)
    800024a4:	e822                	sd	s0,16(sp)
    800024a6:	e426                	sd	s1,8(sp)
    800024a8:	1000                	addi	s0,sp,32
    800024aa:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024ac:	0541                	addi	a0,a0,16
    800024ae:	00001097          	auipc	ra,0x1
    800024b2:	46e080e7          	jalr	1134(ra) # 8000391c <holdingsleep>
    800024b6:	cd01                	beqz	a0,800024ce <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024b8:	4585                	li	a1,1
    800024ba:	8526                	mv	a0,s1
    800024bc:	00003097          	auipc	ra,0x3
    800024c0:	f9c080e7          	jalr	-100(ra) # 80005458 <virtio_disk_rw>
}
    800024c4:	60e2                	ld	ra,24(sp)
    800024c6:	6442                	ld	s0,16(sp)
    800024c8:	64a2                	ld	s1,8(sp)
    800024ca:	6105                	addi	sp,sp,32
    800024cc:	8082                	ret
    panic("bwrite");
    800024ce:	00006517          	auipc	a0,0x6
    800024d2:	15a50513          	addi	a0,a0,346 # 80008628 <syscallnames+0xe0>
    800024d6:	00003097          	auipc	ra,0x3
    800024da:	7ec080e7          	jalr	2028(ra) # 80005cc2 <panic>

00000000800024de <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800024de:	1101                	addi	sp,sp,-32
    800024e0:	ec06                	sd	ra,24(sp)
    800024e2:	e822                	sd	s0,16(sp)
    800024e4:	e426                	sd	s1,8(sp)
    800024e6:	e04a                	sd	s2,0(sp)
    800024e8:	1000                	addi	s0,sp,32
    800024ea:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024ec:	01050913          	addi	s2,a0,16
    800024f0:	854a                	mv	a0,s2
    800024f2:	00001097          	auipc	ra,0x1
    800024f6:	42a080e7          	jalr	1066(ra) # 8000391c <holdingsleep>
    800024fa:	c92d                	beqz	a0,8000256c <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800024fc:	854a                	mv	a0,s2
    800024fe:	00001097          	auipc	ra,0x1
    80002502:	3da080e7          	jalr	986(ra) # 800038d8 <releasesleep>

  acquire(&bcache.lock);
    80002506:	0000c517          	auipc	a0,0xc
    8000250a:	3a250513          	addi	a0,a0,930 # 8000e8a8 <bcache>
    8000250e:	00004097          	auipc	ra,0x4
    80002512:	cfe080e7          	jalr	-770(ra) # 8000620c <acquire>
  b->refcnt--;
    80002516:	40bc                	lw	a5,64(s1)
    80002518:	37fd                	addiw	a5,a5,-1
    8000251a:	0007871b          	sext.w	a4,a5
    8000251e:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002520:	eb05                	bnez	a4,80002550 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002522:	68bc                	ld	a5,80(s1)
    80002524:	64b8                	ld	a4,72(s1)
    80002526:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002528:	64bc                	ld	a5,72(s1)
    8000252a:	68b8                	ld	a4,80(s1)
    8000252c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000252e:	00014797          	auipc	a5,0x14
    80002532:	37a78793          	addi	a5,a5,890 # 800168a8 <bcache+0x8000>
    80002536:	2b87b703          	ld	a4,696(a5)
    8000253a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000253c:	00014717          	auipc	a4,0x14
    80002540:	5d470713          	addi	a4,a4,1492 # 80016b10 <bcache+0x8268>
    80002544:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002546:	2b87b703          	ld	a4,696(a5)
    8000254a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000254c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002550:	0000c517          	auipc	a0,0xc
    80002554:	35850513          	addi	a0,a0,856 # 8000e8a8 <bcache>
    80002558:	00004097          	auipc	ra,0x4
    8000255c:	d68080e7          	jalr	-664(ra) # 800062c0 <release>
}
    80002560:	60e2                	ld	ra,24(sp)
    80002562:	6442                	ld	s0,16(sp)
    80002564:	64a2                	ld	s1,8(sp)
    80002566:	6902                	ld	s2,0(sp)
    80002568:	6105                	addi	sp,sp,32
    8000256a:	8082                	ret
    panic("brelse");
    8000256c:	00006517          	auipc	a0,0x6
    80002570:	0c450513          	addi	a0,a0,196 # 80008630 <syscallnames+0xe8>
    80002574:	00003097          	auipc	ra,0x3
    80002578:	74e080e7          	jalr	1870(ra) # 80005cc2 <panic>

000000008000257c <bpin>:

void
bpin(struct buf *b) {
    8000257c:	1101                	addi	sp,sp,-32
    8000257e:	ec06                	sd	ra,24(sp)
    80002580:	e822                	sd	s0,16(sp)
    80002582:	e426                	sd	s1,8(sp)
    80002584:	1000                	addi	s0,sp,32
    80002586:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002588:	0000c517          	auipc	a0,0xc
    8000258c:	32050513          	addi	a0,a0,800 # 8000e8a8 <bcache>
    80002590:	00004097          	auipc	ra,0x4
    80002594:	c7c080e7          	jalr	-900(ra) # 8000620c <acquire>
  b->refcnt++;
    80002598:	40bc                	lw	a5,64(s1)
    8000259a:	2785                	addiw	a5,a5,1
    8000259c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000259e:	0000c517          	auipc	a0,0xc
    800025a2:	30a50513          	addi	a0,a0,778 # 8000e8a8 <bcache>
    800025a6:	00004097          	auipc	ra,0x4
    800025aa:	d1a080e7          	jalr	-742(ra) # 800062c0 <release>
}
    800025ae:	60e2                	ld	ra,24(sp)
    800025b0:	6442                	ld	s0,16(sp)
    800025b2:	64a2                	ld	s1,8(sp)
    800025b4:	6105                	addi	sp,sp,32
    800025b6:	8082                	ret

00000000800025b8 <bunpin>:

void
bunpin(struct buf *b) {
    800025b8:	1101                	addi	sp,sp,-32
    800025ba:	ec06                	sd	ra,24(sp)
    800025bc:	e822                	sd	s0,16(sp)
    800025be:	e426                	sd	s1,8(sp)
    800025c0:	1000                	addi	s0,sp,32
    800025c2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025c4:	0000c517          	auipc	a0,0xc
    800025c8:	2e450513          	addi	a0,a0,740 # 8000e8a8 <bcache>
    800025cc:	00004097          	auipc	ra,0x4
    800025d0:	c40080e7          	jalr	-960(ra) # 8000620c <acquire>
  b->refcnt--;
    800025d4:	40bc                	lw	a5,64(s1)
    800025d6:	37fd                	addiw	a5,a5,-1
    800025d8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025da:	0000c517          	auipc	a0,0xc
    800025de:	2ce50513          	addi	a0,a0,718 # 8000e8a8 <bcache>
    800025e2:	00004097          	auipc	ra,0x4
    800025e6:	cde080e7          	jalr	-802(ra) # 800062c0 <release>
}
    800025ea:	60e2                	ld	ra,24(sp)
    800025ec:	6442                	ld	s0,16(sp)
    800025ee:	64a2                	ld	s1,8(sp)
    800025f0:	6105                	addi	sp,sp,32
    800025f2:	8082                	ret

00000000800025f4 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800025f4:	1101                	addi	sp,sp,-32
    800025f6:	ec06                	sd	ra,24(sp)
    800025f8:	e822                	sd	s0,16(sp)
    800025fa:	e426                	sd	s1,8(sp)
    800025fc:	e04a                	sd	s2,0(sp)
    800025fe:	1000                	addi	s0,sp,32
    80002600:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002602:	00d5d59b          	srliw	a1,a1,0xd
    80002606:	00015797          	auipc	a5,0x15
    8000260a:	97e7a783          	lw	a5,-1666(a5) # 80016f84 <sb+0x1c>
    8000260e:	9dbd                	addw	a1,a1,a5
    80002610:	00000097          	auipc	ra,0x0
    80002614:	d9e080e7          	jalr	-610(ra) # 800023ae <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002618:	0074f713          	andi	a4,s1,7
    8000261c:	4785                	li	a5,1
    8000261e:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002622:	14ce                	slli	s1,s1,0x33
    80002624:	90d9                	srli	s1,s1,0x36
    80002626:	00950733          	add	a4,a0,s1
    8000262a:	05874703          	lbu	a4,88(a4)
    8000262e:	00e7f6b3          	and	a3,a5,a4
    80002632:	c69d                	beqz	a3,80002660 <bfree+0x6c>
    80002634:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002636:	94aa                	add	s1,s1,a0
    80002638:	fff7c793          	not	a5,a5
    8000263c:	8ff9                	and	a5,a5,a4
    8000263e:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002642:	00001097          	auipc	ra,0x1
    80002646:	120080e7          	jalr	288(ra) # 80003762 <log_write>
  brelse(bp);
    8000264a:	854a                	mv	a0,s2
    8000264c:	00000097          	auipc	ra,0x0
    80002650:	e92080e7          	jalr	-366(ra) # 800024de <brelse>
}
    80002654:	60e2                	ld	ra,24(sp)
    80002656:	6442                	ld	s0,16(sp)
    80002658:	64a2                	ld	s1,8(sp)
    8000265a:	6902                	ld	s2,0(sp)
    8000265c:	6105                	addi	sp,sp,32
    8000265e:	8082                	ret
    panic("freeing free block");
    80002660:	00006517          	auipc	a0,0x6
    80002664:	fd850513          	addi	a0,a0,-40 # 80008638 <syscallnames+0xf0>
    80002668:	00003097          	auipc	ra,0x3
    8000266c:	65a080e7          	jalr	1626(ra) # 80005cc2 <panic>

0000000080002670 <balloc>:
{
    80002670:	711d                	addi	sp,sp,-96
    80002672:	ec86                	sd	ra,88(sp)
    80002674:	e8a2                	sd	s0,80(sp)
    80002676:	e4a6                	sd	s1,72(sp)
    80002678:	e0ca                	sd	s2,64(sp)
    8000267a:	fc4e                	sd	s3,56(sp)
    8000267c:	f852                	sd	s4,48(sp)
    8000267e:	f456                	sd	s5,40(sp)
    80002680:	f05a                	sd	s6,32(sp)
    80002682:	ec5e                	sd	s7,24(sp)
    80002684:	e862                	sd	s8,16(sp)
    80002686:	e466                	sd	s9,8(sp)
    80002688:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000268a:	00015797          	auipc	a5,0x15
    8000268e:	8e27a783          	lw	a5,-1822(a5) # 80016f6c <sb+0x4>
    80002692:	10078163          	beqz	a5,80002794 <balloc+0x124>
    80002696:	8baa                	mv	s7,a0
    80002698:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000269a:	00015b17          	auipc	s6,0x15
    8000269e:	8ceb0b13          	addi	s6,s6,-1842 # 80016f68 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026a2:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026a4:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026a6:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026a8:	6c89                	lui	s9,0x2
    800026aa:	a061                	j	80002732 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    800026ac:	974a                	add	a4,a4,s2
    800026ae:	8fd5                	or	a5,a5,a3
    800026b0:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800026b4:	854a                	mv	a0,s2
    800026b6:	00001097          	auipc	ra,0x1
    800026ba:	0ac080e7          	jalr	172(ra) # 80003762 <log_write>
        brelse(bp);
    800026be:	854a                	mv	a0,s2
    800026c0:	00000097          	auipc	ra,0x0
    800026c4:	e1e080e7          	jalr	-482(ra) # 800024de <brelse>
  bp = bread(dev, bno);
    800026c8:	85a6                	mv	a1,s1
    800026ca:	855e                	mv	a0,s7
    800026cc:	00000097          	auipc	ra,0x0
    800026d0:	ce2080e7          	jalr	-798(ra) # 800023ae <bread>
    800026d4:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800026d6:	40000613          	li	a2,1024
    800026da:	4581                	li	a1,0
    800026dc:	05850513          	addi	a0,a0,88
    800026e0:	ffffe097          	auipc	ra,0xffffe
    800026e4:	a98080e7          	jalr	-1384(ra) # 80000178 <memset>
  log_write(bp);
    800026e8:	854a                	mv	a0,s2
    800026ea:	00001097          	auipc	ra,0x1
    800026ee:	078080e7          	jalr	120(ra) # 80003762 <log_write>
  brelse(bp);
    800026f2:	854a                	mv	a0,s2
    800026f4:	00000097          	auipc	ra,0x0
    800026f8:	dea080e7          	jalr	-534(ra) # 800024de <brelse>
}
    800026fc:	8526                	mv	a0,s1
    800026fe:	60e6                	ld	ra,88(sp)
    80002700:	6446                	ld	s0,80(sp)
    80002702:	64a6                	ld	s1,72(sp)
    80002704:	6906                	ld	s2,64(sp)
    80002706:	79e2                	ld	s3,56(sp)
    80002708:	7a42                	ld	s4,48(sp)
    8000270a:	7aa2                	ld	s5,40(sp)
    8000270c:	7b02                	ld	s6,32(sp)
    8000270e:	6be2                	ld	s7,24(sp)
    80002710:	6c42                	ld	s8,16(sp)
    80002712:	6ca2                	ld	s9,8(sp)
    80002714:	6125                	addi	sp,sp,96
    80002716:	8082                	ret
    brelse(bp);
    80002718:	854a                	mv	a0,s2
    8000271a:	00000097          	auipc	ra,0x0
    8000271e:	dc4080e7          	jalr	-572(ra) # 800024de <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002722:	015c87bb          	addw	a5,s9,s5
    80002726:	00078a9b          	sext.w	s5,a5
    8000272a:	004b2703          	lw	a4,4(s6)
    8000272e:	06eaf363          	bgeu	s5,a4,80002794 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    80002732:	41fad79b          	sraiw	a5,s5,0x1f
    80002736:	0137d79b          	srliw	a5,a5,0x13
    8000273a:	015787bb          	addw	a5,a5,s5
    8000273e:	40d7d79b          	sraiw	a5,a5,0xd
    80002742:	01cb2583          	lw	a1,28(s6)
    80002746:	9dbd                	addw	a1,a1,a5
    80002748:	855e                	mv	a0,s7
    8000274a:	00000097          	auipc	ra,0x0
    8000274e:	c64080e7          	jalr	-924(ra) # 800023ae <bread>
    80002752:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002754:	004b2503          	lw	a0,4(s6)
    80002758:	000a849b          	sext.w	s1,s5
    8000275c:	8662                	mv	a2,s8
    8000275e:	faa4fde3          	bgeu	s1,a0,80002718 <balloc+0xa8>
      m = 1 << (bi % 8);
    80002762:	41f6579b          	sraiw	a5,a2,0x1f
    80002766:	01d7d69b          	srliw	a3,a5,0x1d
    8000276a:	00c6873b          	addw	a4,a3,a2
    8000276e:	00777793          	andi	a5,a4,7
    80002772:	9f95                	subw	a5,a5,a3
    80002774:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002778:	4037571b          	sraiw	a4,a4,0x3
    8000277c:	00e906b3          	add	a3,s2,a4
    80002780:	0586c683          	lbu	a3,88(a3)
    80002784:	00d7f5b3          	and	a1,a5,a3
    80002788:	d195                	beqz	a1,800026ac <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000278a:	2605                	addiw	a2,a2,1
    8000278c:	2485                	addiw	s1,s1,1
    8000278e:	fd4618e3          	bne	a2,s4,8000275e <balloc+0xee>
    80002792:	b759                	j	80002718 <balloc+0xa8>
  printf("balloc: out of blocks\n");
    80002794:	00006517          	auipc	a0,0x6
    80002798:	ebc50513          	addi	a0,a0,-324 # 80008650 <syscallnames+0x108>
    8000279c:	00003097          	auipc	ra,0x3
    800027a0:	570080e7          	jalr	1392(ra) # 80005d0c <printf>
  return 0;
    800027a4:	4481                	li	s1,0
    800027a6:	bf99                	j	800026fc <balloc+0x8c>

00000000800027a8 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800027a8:	7179                	addi	sp,sp,-48
    800027aa:	f406                	sd	ra,40(sp)
    800027ac:	f022                	sd	s0,32(sp)
    800027ae:	ec26                	sd	s1,24(sp)
    800027b0:	e84a                	sd	s2,16(sp)
    800027b2:	e44e                	sd	s3,8(sp)
    800027b4:	e052                	sd	s4,0(sp)
    800027b6:	1800                	addi	s0,sp,48
    800027b8:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027ba:	47ad                	li	a5,11
    800027bc:	02b7e763          	bltu	a5,a1,800027ea <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    800027c0:	02059493          	slli	s1,a1,0x20
    800027c4:	9081                	srli	s1,s1,0x20
    800027c6:	048a                	slli	s1,s1,0x2
    800027c8:	94aa                	add	s1,s1,a0
    800027ca:	0504a903          	lw	s2,80(s1)
    800027ce:	06091e63          	bnez	s2,8000284a <bmap+0xa2>
      addr = balloc(ip->dev);
    800027d2:	4108                	lw	a0,0(a0)
    800027d4:	00000097          	auipc	ra,0x0
    800027d8:	e9c080e7          	jalr	-356(ra) # 80002670 <balloc>
    800027dc:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800027e0:	06090563          	beqz	s2,8000284a <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    800027e4:	0524a823          	sw	s2,80(s1)
    800027e8:	a08d                	j	8000284a <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    800027ea:	ff45849b          	addiw	s1,a1,-12
    800027ee:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027f2:	0ff00793          	li	a5,255
    800027f6:	08e7e563          	bltu	a5,a4,80002880 <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800027fa:	08052903          	lw	s2,128(a0)
    800027fe:	00091d63          	bnez	s2,80002818 <bmap+0x70>
      addr = balloc(ip->dev);
    80002802:	4108                	lw	a0,0(a0)
    80002804:	00000097          	auipc	ra,0x0
    80002808:	e6c080e7          	jalr	-404(ra) # 80002670 <balloc>
    8000280c:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002810:	02090d63          	beqz	s2,8000284a <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002814:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002818:	85ca                	mv	a1,s2
    8000281a:	0009a503          	lw	a0,0(s3)
    8000281e:	00000097          	auipc	ra,0x0
    80002822:	b90080e7          	jalr	-1136(ra) # 800023ae <bread>
    80002826:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002828:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000282c:	02049593          	slli	a1,s1,0x20
    80002830:	9181                	srli	a1,a1,0x20
    80002832:	058a                	slli	a1,a1,0x2
    80002834:	00b784b3          	add	s1,a5,a1
    80002838:	0004a903          	lw	s2,0(s1)
    8000283c:	02090063          	beqz	s2,8000285c <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002840:	8552                	mv	a0,s4
    80002842:	00000097          	auipc	ra,0x0
    80002846:	c9c080e7          	jalr	-868(ra) # 800024de <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000284a:	854a                	mv	a0,s2
    8000284c:	70a2                	ld	ra,40(sp)
    8000284e:	7402                	ld	s0,32(sp)
    80002850:	64e2                	ld	s1,24(sp)
    80002852:	6942                	ld	s2,16(sp)
    80002854:	69a2                	ld	s3,8(sp)
    80002856:	6a02                	ld	s4,0(sp)
    80002858:	6145                	addi	sp,sp,48
    8000285a:	8082                	ret
      addr = balloc(ip->dev);
    8000285c:	0009a503          	lw	a0,0(s3)
    80002860:	00000097          	auipc	ra,0x0
    80002864:	e10080e7          	jalr	-496(ra) # 80002670 <balloc>
    80002868:	0005091b          	sext.w	s2,a0
      if(addr){
    8000286c:	fc090ae3          	beqz	s2,80002840 <bmap+0x98>
        a[bn] = addr;
    80002870:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002874:	8552                	mv	a0,s4
    80002876:	00001097          	auipc	ra,0x1
    8000287a:	eec080e7          	jalr	-276(ra) # 80003762 <log_write>
    8000287e:	b7c9                	j	80002840 <bmap+0x98>
  panic("bmap: out of range");
    80002880:	00006517          	auipc	a0,0x6
    80002884:	de850513          	addi	a0,a0,-536 # 80008668 <syscallnames+0x120>
    80002888:	00003097          	auipc	ra,0x3
    8000288c:	43a080e7          	jalr	1082(ra) # 80005cc2 <panic>

0000000080002890 <iget>:
{
    80002890:	7179                	addi	sp,sp,-48
    80002892:	f406                	sd	ra,40(sp)
    80002894:	f022                	sd	s0,32(sp)
    80002896:	ec26                	sd	s1,24(sp)
    80002898:	e84a                	sd	s2,16(sp)
    8000289a:	e44e                	sd	s3,8(sp)
    8000289c:	e052                	sd	s4,0(sp)
    8000289e:	1800                	addi	s0,sp,48
    800028a0:	89aa                	mv	s3,a0
    800028a2:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028a4:	00014517          	auipc	a0,0x14
    800028a8:	6e450513          	addi	a0,a0,1764 # 80016f88 <itable>
    800028ac:	00004097          	auipc	ra,0x4
    800028b0:	960080e7          	jalr	-1696(ra) # 8000620c <acquire>
  empty = 0;
    800028b4:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028b6:	00014497          	auipc	s1,0x14
    800028ba:	6ea48493          	addi	s1,s1,1770 # 80016fa0 <itable+0x18>
    800028be:	00016697          	auipc	a3,0x16
    800028c2:	17268693          	addi	a3,a3,370 # 80018a30 <log>
    800028c6:	a039                	j	800028d4 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028c8:	02090b63          	beqz	s2,800028fe <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028cc:	08848493          	addi	s1,s1,136
    800028d0:	02d48a63          	beq	s1,a3,80002904 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028d4:	449c                	lw	a5,8(s1)
    800028d6:	fef059e3          	blez	a5,800028c8 <iget+0x38>
    800028da:	4098                	lw	a4,0(s1)
    800028dc:	ff3716e3          	bne	a4,s3,800028c8 <iget+0x38>
    800028e0:	40d8                	lw	a4,4(s1)
    800028e2:	ff4713e3          	bne	a4,s4,800028c8 <iget+0x38>
      ip->ref++;
    800028e6:	2785                	addiw	a5,a5,1
    800028e8:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028ea:	00014517          	auipc	a0,0x14
    800028ee:	69e50513          	addi	a0,a0,1694 # 80016f88 <itable>
    800028f2:	00004097          	auipc	ra,0x4
    800028f6:	9ce080e7          	jalr	-1586(ra) # 800062c0 <release>
      return ip;
    800028fa:	8926                	mv	s2,s1
    800028fc:	a03d                	j	8000292a <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028fe:	f7f9                	bnez	a5,800028cc <iget+0x3c>
    80002900:	8926                	mv	s2,s1
    80002902:	b7e9                	j	800028cc <iget+0x3c>
  if(empty == 0)
    80002904:	02090c63          	beqz	s2,8000293c <iget+0xac>
  ip->dev = dev;
    80002908:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000290c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002910:	4785                	li	a5,1
    80002912:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002916:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000291a:	00014517          	auipc	a0,0x14
    8000291e:	66e50513          	addi	a0,a0,1646 # 80016f88 <itable>
    80002922:	00004097          	auipc	ra,0x4
    80002926:	99e080e7          	jalr	-1634(ra) # 800062c0 <release>
}
    8000292a:	854a                	mv	a0,s2
    8000292c:	70a2                	ld	ra,40(sp)
    8000292e:	7402                	ld	s0,32(sp)
    80002930:	64e2                	ld	s1,24(sp)
    80002932:	6942                	ld	s2,16(sp)
    80002934:	69a2                	ld	s3,8(sp)
    80002936:	6a02                	ld	s4,0(sp)
    80002938:	6145                	addi	sp,sp,48
    8000293a:	8082                	ret
    panic("iget: no inodes");
    8000293c:	00006517          	auipc	a0,0x6
    80002940:	d4450513          	addi	a0,a0,-700 # 80008680 <syscallnames+0x138>
    80002944:	00003097          	auipc	ra,0x3
    80002948:	37e080e7          	jalr	894(ra) # 80005cc2 <panic>

000000008000294c <fsinit>:
fsinit(int dev) {
    8000294c:	7179                	addi	sp,sp,-48
    8000294e:	f406                	sd	ra,40(sp)
    80002950:	f022                	sd	s0,32(sp)
    80002952:	ec26                	sd	s1,24(sp)
    80002954:	e84a                	sd	s2,16(sp)
    80002956:	e44e                	sd	s3,8(sp)
    80002958:	1800                	addi	s0,sp,48
    8000295a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000295c:	4585                	li	a1,1
    8000295e:	00000097          	auipc	ra,0x0
    80002962:	a50080e7          	jalr	-1456(ra) # 800023ae <bread>
    80002966:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002968:	00014997          	auipc	s3,0x14
    8000296c:	60098993          	addi	s3,s3,1536 # 80016f68 <sb>
    80002970:	02000613          	li	a2,32
    80002974:	05850593          	addi	a1,a0,88
    80002978:	854e                	mv	a0,s3
    8000297a:	ffffe097          	auipc	ra,0xffffe
    8000297e:	85e080e7          	jalr	-1954(ra) # 800001d8 <memmove>
  brelse(bp);
    80002982:	8526                	mv	a0,s1
    80002984:	00000097          	auipc	ra,0x0
    80002988:	b5a080e7          	jalr	-1190(ra) # 800024de <brelse>
  if(sb.magic != FSMAGIC)
    8000298c:	0009a703          	lw	a4,0(s3)
    80002990:	102037b7          	lui	a5,0x10203
    80002994:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002998:	02f71263          	bne	a4,a5,800029bc <fsinit+0x70>
  initlog(dev, &sb);
    8000299c:	00014597          	auipc	a1,0x14
    800029a0:	5cc58593          	addi	a1,a1,1484 # 80016f68 <sb>
    800029a4:	854a                	mv	a0,s2
    800029a6:	00001097          	auipc	ra,0x1
    800029aa:	b40080e7          	jalr	-1216(ra) # 800034e6 <initlog>
}
    800029ae:	70a2                	ld	ra,40(sp)
    800029b0:	7402                	ld	s0,32(sp)
    800029b2:	64e2                	ld	s1,24(sp)
    800029b4:	6942                	ld	s2,16(sp)
    800029b6:	69a2                	ld	s3,8(sp)
    800029b8:	6145                	addi	sp,sp,48
    800029ba:	8082                	ret
    panic("invalid file system");
    800029bc:	00006517          	auipc	a0,0x6
    800029c0:	cd450513          	addi	a0,a0,-812 # 80008690 <syscallnames+0x148>
    800029c4:	00003097          	auipc	ra,0x3
    800029c8:	2fe080e7          	jalr	766(ra) # 80005cc2 <panic>

00000000800029cc <iinit>:
{
    800029cc:	7179                	addi	sp,sp,-48
    800029ce:	f406                	sd	ra,40(sp)
    800029d0:	f022                	sd	s0,32(sp)
    800029d2:	ec26                	sd	s1,24(sp)
    800029d4:	e84a                	sd	s2,16(sp)
    800029d6:	e44e                	sd	s3,8(sp)
    800029d8:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029da:	00006597          	auipc	a1,0x6
    800029de:	cce58593          	addi	a1,a1,-818 # 800086a8 <syscallnames+0x160>
    800029e2:	00014517          	auipc	a0,0x14
    800029e6:	5a650513          	addi	a0,a0,1446 # 80016f88 <itable>
    800029ea:	00003097          	auipc	ra,0x3
    800029ee:	792080e7          	jalr	1938(ra) # 8000617c <initlock>
  for(i = 0; i < NINODE; i++) {
    800029f2:	00014497          	auipc	s1,0x14
    800029f6:	5be48493          	addi	s1,s1,1470 # 80016fb0 <itable+0x28>
    800029fa:	00016997          	auipc	s3,0x16
    800029fe:	04698993          	addi	s3,s3,70 # 80018a40 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a02:	00006917          	auipc	s2,0x6
    80002a06:	cae90913          	addi	s2,s2,-850 # 800086b0 <syscallnames+0x168>
    80002a0a:	85ca                	mv	a1,s2
    80002a0c:	8526                	mv	a0,s1
    80002a0e:	00001097          	auipc	ra,0x1
    80002a12:	e3a080e7          	jalr	-454(ra) # 80003848 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a16:	08848493          	addi	s1,s1,136
    80002a1a:	ff3498e3          	bne	s1,s3,80002a0a <iinit+0x3e>
}
    80002a1e:	70a2                	ld	ra,40(sp)
    80002a20:	7402                	ld	s0,32(sp)
    80002a22:	64e2                	ld	s1,24(sp)
    80002a24:	6942                	ld	s2,16(sp)
    80002a26:	69a2                	ld	s3,8(sp)
    80002a28:	6145                	addi	sp,sp,48
    80002a2a:	8082                	ret

0000000080002a2c <ialloc>:
{
    80002a2c:	715d                	addi	sp,sp,-80
    80002a2e:	e486                	sd	ra,72(sp)
    80002a30:	e0a2                	sd	s0,64(sp)
    80002a32:	fc26                	sd	s1,56(sp)
    80002a34:	f84a                	sd	s2,48(sp)
    80002a36:	f44e                	sd	s3,40(sp)
    80002a38:	f052                	sd	s4,32(sp)
    80002a3a:	ec56                	sd	s5,24(sp)
    80002a3c:	e85a                	sd	s6,16(sp)
    80002a3e:	e45e                	sd	s7,8(sp)
    80002a40:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a42:	00014717          	auipc	a4,0x14
    80002a46:	53272703          	lw	a4,1330(a4) # 80016f74 <sb+0xc>
    80002a4a:	4785                	li	a5,1
    80002a4c:	04e7fa63          	bgeu	a5,a4,80002aa0 <ialloc+0x74>
    80002a50:	8aaa                	mv	s5,a0
    80002a52:	8bae                	mv	s7,a1
    80002a54:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a56:	00014a17          	auipc	s4,0x14
    80002a5a:	512a0a13          	addi	s4,s4,1298 # 80016f68 <sb>
    80002a5e:	00048b1b          	sext.w	s6,s1
    80002a62:	0044d593          	srli	a1,s1,0x4
    80002a66:	018a2783          	lw	a5,24(s4)
    80002a6a:	9dbd                	addw	a1,a1,a5
    80002a6c:	8556                	mv	a0,s5
    80002a6e:	00000097          	auipc	ra,0x0
    80002a72:	940080e7          	jalr	-1728(ra) # 800023ae <bread>
    80002a76:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a78:	05850993          	addi	s3,a0,88
    80002a7c:	00f4f793          	andi	a5,s1,15
    80002a80:	079a                	slli	a5,a5,0x6
    80002a82:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a84:	00099783          	lh	a5,0(s3)
    80002a88:	c3a1                	beqz	a5,80002ac8 <ialloc+0x9c>
    brelse(bp);
    80002a8a:	00000097          	auipc	ra,0x0
    80002a8e:	a54080e7          	jalr	-1452(ra) # 800024de <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a92:	0485                	addi	s1,s1,1
    80002a94:	00ca2703          	lw	a4,12(s4)
    80002a98:	0004879b          	sext.w	a5,s1
    80002a9c:	fce7e1e3          	bltu	a5,a4,80002a5e <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002aa0:	00006517          	auipc	a0,0x6
    80002aa4:	c1850513          	addi	a0,a0,-1000 # 800086b8 <syscallnames+0x170>
    80002aa8:	00003097          	auipc	ra,0x3
    80002aac:	264080e7          	jalr	612(ra) # 80005d0c <printf>
  return 0;
    80002ab0:	4501                	li	a0,0
}
    80002ab2:	60a6                	ld	ra,72(sp)
    80002ab4:	6406                	ld	s0,64(sp)
    80002ab6:	74e2                	ld	s1,56(sp)
    80002ab8:	7942                	ld	s2,48(sp)
    80002aba:	79a2                	ld	s3,40(sp)
    80002abc:	7a02                	ld	s4,32(sp)
    80002abe:	6ae2                	ld	s5,24(sp)
    80002ac0:	6b42                	ld	s6,16(sp)
    80002ac2:	6ba2                	ld	s7,8(sp)
    80002ac4:	6161                	addi	sp,sp,80
    80002ac6:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002ac8:	04000613          	li	a2,64
    80002acc:	4581                	li	a1,0
    80002ace:	854e                	mv	a0,s3
    80002ad0:	ffffd097          	auipc	ra,0xffffd
    80002ad4:	6a8080e7          	jalr	1704(ra) # 80000178 <memset>
      dip->type = type;
    80002ad8:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002adc:	854a                	mv	a0,s2
    80002ade:	00001097          	auipc	ra,0x1
    80002ae2:	c84080e7          	jalr	-892(ra) # 80003762 <log_write>
      brelse(bp);
    80002ae6:	854a                	mv	a0,s2
    80002ae8:	00000097          	auipc	ra,0x0
    80002aec:	9f6080e7          	jalr	-1546(ra) # 800024de <brelse>
      return iget(dev, inum);
    80002af0:	85da                	mv	a1,s6
    80002af2:	8556                	mv	a0,s5
    80002af4:	00000097          	auipc	ra,0x0
    80002af8:	d9c080e7          	jalr	-612(ra) # 80002890 <iget>
    80002afc:	bf5d                	j	80002ab2 <ialloc+0x86>

0000000080002afe <iupdate>:
{
    80002afe:	1101                	addi	sp,sp,-32
    80002b00:	ec06                	sd	ra,24(sp)
    80002b02:	e822                	sd	s0,16(sp)
    80002b04:	e426                	sd	s1,8(sp)
    80002b06:	e04a                	sd	s2,0(sp)
    80002b08:	1000                	addi	s0,sp,32
    80002b0a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b0c:	415c                	lw	a5,4(a0)
    80002b0e:	0047d79b          	srliw	a5,a5,0x4
    80002b12:	00014597          	auipc	a1,0x14
    80002b16:	46e5a583          	lw	a1,1134(a1) # 80016f80 <sb+0x18>
    80002b1a:	9dbd                	addw	a1,a1,a5
    80002b1c:	4108                	lw	a0,0(a0)
    80002b1e:	00000097          	auipc	ra,0x0
    80002b22:	890080e7          	jalr	-1904(ra) # 800023ae <bread>
    80002b26:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b28:	05850793          	addi	a5,a0,88
    80002b2c:	40c8                	lw	a0,4(s1)
    80002b2e:	893d                	andi	a0,a0,15
    80002b30:	051a                	slli	a0,a0,0x6
    80002b32:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002b34:	04449703          	lh	a4,68(s1)
    80002b38:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002b3c:	04649703          	lh	a4,70(s1)
    80002b40:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002b44:	04849703          	lh	a4,72(s1)
    80002b48:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002b4c:	04a49703          	lh	a4,74(s1)
    80002b50:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002b54:	44f8                	lw	a4,76(s1)
    80002b56:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b58:	03400613          	li	a2,52
    80002b5c:	05048593          	addi	a1,s1,80
    80002b60:	0531                	addi	a0,a0,12
    80002b62:	ffffd097          	auipc	ra,0xffffd
    80002b66:	676080e7          	jalr	1654(ra) # 800001d8 <memmove>
  log_write(bp);
    80002b6a:	854a                	mv	a0,s2
    80002b6c:	00001097          	auipc	ra,0x1
    80002b70:	bf6080e7          	jalr	-1034(ra) # 80003762 <log_write>
  brelse(bp);
    80002b74:	854a                	mv	a0,s2
    80002b76:	00000097          	auipc	ra,0x0
    80002b7a:	968080e7          	jalr	-1688(ra) # 800024de <brelse>
}
    80002b7e:	60e2                	ld	ra,24(sp)
    80002b80:	6442                	ld	s0,16(sp)
    80002b82:	64a2                	ld	s1,8(sp)
    80002b84:	6902                	ld	s2,0(sp)
    80002b86:	6105                	addi	sp,sp,32
    80002b88:	8082                	ret

0000000080002b8a <idup>:
{
    80002b8a:	1101                	addi	sp,sp,-32
    80002b8c:	ec06                	sd	ra,24(sp)
    80002b8e:	e822                	sd	s0,16(sp)
    80002b90:	e426                	sd	s1,8(sp)
    80002b92:	1000                	addi	s0,sp,32
    80002b94:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b96:	00014517          	auipc	a0,0x14
    80002b9a:	3f250513          	addi	a0,a0,1010 # 80016f88 <itable>
    80002b9e:	00003097          	auipc	ra,0x3
    80002ba2:	66e080e7          	jalr	1646(ra) # 8000620c <acquire>
  ip->ref++;
    80002ba6:	449c                	lw	a5,8(s1)
    80002ba8:	2785                	addiw	a5,a5,1
    80002baa:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002bac:	00014517          	auipc	a0,0x14
    80002bb0:	3dc50513          	addi	a0,a0,988 # 80016f88 <itable>
    80002bb4:	00003097          	auipc	ra,0x3
    80002bb8:	70c080e7          	jalr	1804(ra) # 800062c0 <release>
}
    80002bbc:	8526                	mv	a0,s1
    80002bbe:	60e2                	ld	ra,24(sp)
    80002bc0:	6442                	ld	s0,16(sp)
    80002bc2:	64a2                	ld	s1,8(sp)
    80002bc4:	6105                	addi	sp,sp,32
    80002bc6:	8082                	ret

0000000080002bc8 <ilock>:
{
    80002bc8:	1101                	addi	sp,sp,-32
    80002bca:	ec06                	sd	ra,24(sp)
    80002bcc:	e822                	sd	s0,16(sp)
    80002bce:	e426                	sd	s1,8(sp)
    80002bd0:	e04a                	sd	s2,0(sp)
    80002bd2:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002bd4:	c115                	beqz	a0,80002bf8 <ilock+0x30>
    80002bd6:	84aa                	mv	s1,a0
    80002bd8:	451c                	lw	a5,8(a0)
    80002bda:	00f05f63          	blez	a5,80002bf8 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002bde:	0541                	addi	a0,a0,16
    80002be0:	00001097          	auipc	ra,0x1
    80002be4:	ca2080e7          	jalr	-862(ra) # 80003882 <acquiresleep>
  if(ip->valid == 0){
    80002be8:	40bc                	lw	a5,64(s1)
    80002bea:	cf99                	beqz	a5,80002c08 <ilock+0x40>
}
    80002bec:	60e2                	ld	ra,24(sp)
    80002bee:	6442                	ld	s0,16(sp)
    80002bf0:	64a2                	ld	s1,8(sp)
    80002bf2:	6902                	ld	s2,0(sp)
    80002bf4:	6105                	addi	sp,sp,32
    80002bf6:	8082                	ret
    panic("ilock");
    80002bf8:	00006517          	auipc	a0,0x6
    80002bfc:	ad850513          	addi	a0,a0,-1320 # 800086d0 <syscallnames+0x188>
    80002c00:	00003097          	auipc	ra,0x3
    80002c04:	0c2080e7          	jalr	194(ra) # 80005cc2 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c08:	40dc                	lw	a5,4(s1)
    80002c0a:	0047d79b          	srliw	a5,a5,0x4
    80002c0e:	00014597          	auipc	a1,0x14
    80002c12:	3725a583          	lw	a1,882(a1) # 80016f80 <sb+0x18>
    80002c16:	9dbd                	addw	a1,a1,a5
    80002c18:	4088                	lw	a0,0(s1)
    80002c1a:	fffff097          	auipc	ra,0xfffff
    80002c1e:	794080e7          	jalr	1940(ra) # 800023ae <bread>
    80002c22:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c24:	05850593          	addi	a1,a0,88
    80002c28:	40dc                	lw	a5,4(s1)
    80002c2a:	8bbd                	andi	a5,a5,15
    80002c2c:	079a                	slli	a5,a5,0x6
    80002c2e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c30:	00059783          	lh	a5,0(a1)
    80002c34:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c38:	00259783          	lh	a5,2(a1)
    80002c3c:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c40:	00459783          	lh	a5,4(a1)
    80002c44:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c48:	00659783          	lh	a5,6(a1)
    80002c4c:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c50:	459c                	lw	a5,8(a1)
    80002c52:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c54:	03400613          	li	a2,52
    80002c58:	05b1                	addi	a1,a1,12
    80002c5a:	05048513          	addi	a0,s1,80
    80002c5e:	ffffd097          	auipc	ra,0xffffd
    80002c62:	57a080e7          	jalr	1402(ra) # 800001d8 <memmove>
    brelse(bp);
    80002c66:	854a                	mv	a0,s2
    80002c68:	00000097          	auipc	ra,0x0
    80002c6c:	876080e7          	jalr	-1930(ra) # 800024de <brelse>
    ip->valid = 1;
    80002c70:	4785                	li	a5,1
    80002c72:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c74:	04449783          	lh	a5,68(s1)
    80002c78:	fbb5                	bnez	a5,80002bec <ilock+0x24>
      panic("ilock: no type");
    80002c7a:	00006517          	auipc	a0,0x6
    80002c7e:	a5e50513          	addi	a0,a0,-1442 # 800086d8 <syscallnames+0x190>
    80002c82:	00003097          	auipc	ra,0x3
    80002c86:	040080e7          	jalr	64(ra) # 80005cc2 <panic>

0000000080002c8a <iunlock>:
{
    80002c8a:	1101                	addi	sp,sp,-32
    80002c8c:	ec06                	sd	ra,24(sp)
    80002c8e:	e822                	sd	s0,16(sp)
    80002c90:	e426                	sd	s1,8(sp)
    80002c92:	e04a                	sd	s2,0(sp)
    80002c94:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c96:	c905                	beqz	a0,80002cc6 <iunlock+0x3c>
    80002c98:	84aa                	mv	s1,a0
    80002c9a:	01050913          	addi	s2,a0,16
    80002c9e:	854a                	mv	a0,s2
    80002ca0:	00001097          	auipc	ra,0x1
    80002ca4:	c7c080e7          	jalr	-900(ra) # 8000391c <holdingsleep>
    80002ca8:	cd19                	beqz	a0,80002cc6 <iunlock+0x3c>
    80002caa:	449c                	lw	a5,8(s1)
    80002cac:	00f05d63          	blez	a5,80002cc6 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002cb0:	854a                	mv	a0,s2
    80002cb2:	00001097          	auipc	ra,0x1
    80002cb6:	c26080e7          	jalr	-986(ra) # 800038d8 <releasesleep>
}
    80002cba:	60e2                	ld	ra,24(sp)
    80002cbc:	6442                	ld	s0,16(sp)
    80002cbe:	64a2                	ld	s1,8(sp)
    80002cc0:	6902                	ld	s2,0(sp)
    80002cc2:	6105                	addi	sp,sp,32
    80002cc4:	8082                	ret
    panic("iunlock");
    80002cc6:	00006517          	auipc	a0,0x6
    80002cca:	a2250513          	addi	a0,a0,-1502 # 800086e8 <syscallnames+0x1a0>
    80002cce:	00003097          	auipc	ra,0x3
    80002cd2:	ff4080e7          	jalr	-12(ra) # 80005cc2 <panic>

0000000080002cd6 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002cd6:	7179                	addi	sp,sp,-48
    80002cd8:	f406                	sd	ra,40(sp)
    80002cda:	f022                	sd	s0,32(sp)
    80002cdc:	ec26                	sd	s1,24(sp)
    80002cde:	e84a                	sd	s2,16(sp)
    80002ce0:	e44e                	sd	s3,8(sp)
    80002ce2:	e052                	sd	s4,0(sp)
    80002ce4:	1800                	addi	s0,sp,48
    80002ce6:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002ce8:	05050493          	addi	s1,a0,80
    80002cec:	08050913          	addi	s2,a0,128
    80002cf0:	a021                	j	80002cf8 <itrunc+0x22>
    80002cf2:	0491                	addi	s1,s1,4
    80002cf4:	01248d63          	beq	s1,s2,80002d0e <itrunc+0x38>
    if(ip->addrs[i]){
    80002cf8:	408c                	lw	a1,0(s1)
    80002cfa:	dde5                	beqz	a1,80002cf2 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002cfc:	0009a503          	lw	a0,0(s3)
    80002d00:	00000097          	auipc	ra,0x0
    80002d04:	8f4080e7          	jalr	-1804(ra) # 800025f4 <bfree>
      ip->addrs[i] = 0;
    80002d08:	0004a023          	sw	zero,0(s1)
    80002d0c:	b7dd                	j	80002cf2 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d0e:	0809a583          	lw	a1,128(s3)
    80002d12:	e185                	bnez	a1,80002d32 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d14:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d18:	854e                	mv	a0,s3
    80002d1a:	00000097          	auipc	ra,0x0
    80002d1e:	de4080e7          	jalr	-540(ra) # 80002afe <iupdate>
}
    80002d22:	70a2                	ld	ra,40(sp)
    80002d24:	7402                	ld	s0,32(sp)
    80002d26:	64e2                	ld	s1,24(sp)
    80002d28:	6942                	ld	s2,16(sp)
    80002d2a:	69a2                	ld	s3,8(sp)
    80002d2c:	6a02                	ld	s4,0(sp)
    80002d2e:	6145                	addi	sp,sp,48
    80002d30:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d32:	0009a503          	lw	a0,0(s3)
    80002d36:	fffff097          	auipc	ra,0xfffff
    80002d3a:	678080e7          	jalr	1656(ra) # 800023ae <bread>
    80002d3e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d40:	05850493          	addi	s1,a0,88
    80002d44:	45850913          	addi	s2,a0,1112
    80002d48:	a811                	j	80002d5c <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002d4a:	0009a503          	lw	a0,0(s3)
    80002d4e:	00000097          	auipc	ra,0x0
    80002d52:	8a6080e7          	jalr	-1882(ra) # 800025f4 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002d56:	0491                	addi	s1,s1,4
    80002d58:	01248563          	beq	s1,s2,80002d62 <itrunc+0x8c>
      if(a[j])
    80002d5c:	408c                	lw	a1,0(s1)
    80002d5e:	dde5                	beqz	a1,80002d56 <itrunc+0x80>
    80002d60:	b7ed                	j	80002d4a <itrunc+0x74>
    brelse(bp);
    80002d62:	8552                	mv	a0,s4
    80002d64:	fffff097          	auipc	ra,0xfffff
    80002d68:	77a080e7          	jalr	1914(ra) # 800024de <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d6c:	0809a583          	lw	a1,128(s3)
    80002d70:	0009a503          	lw	a0,0(s3)
    80002d74:	00000097          	auipc	ra,0x0
    80002d78:	880080e7          	jalr	-1920(ra) # 800025f4 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d7c:	0809a023          	sw	zero,128(s3)
    80002d80:	bf51                	j	80002d14 <itrunc+0x3e>

0000000080002d82 <iput>:
{
    80002d82:	1101                	addi	sp,sp,-32
    80002d84:	ec06                	sd	ra,24(sp)
    80002d86:	e822                	sd	s0,16(sp)
    80002d88:	e426                	sd	s1,8(sp)
    80002d8a:	e04a                	sd	s2,0(sp)
    80002d8c:	1000                	addi	s0,sp,32
    80002d8e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d90:	00014517          	auipc	a0,0x14
    80002d94:	1f850513          	addi	a0,a0,504 # 80016f88 <itable>
    80002d98:	00003097          	auipc	ra,0x3
    80002d9c:	474080e7          	jalr	1140(ra) # 8000620c <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002da0:	4498                	lw	a4,8(s1)
    80002da2:	4785                	li	a5,1
    80002da4:	02f70363          	beq	a4,a5,80002dca <iput+0x48>
  ip->ref--;
    80002da8:	449c                	lw	a5,8(s1)
    80002daa:	37fd                	addiw	a5,a5,-1
    80002dac:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002dae:	00014517          	auipc	a0,0x14
    80002db2:	1da50513          	addi	a0,a0,474 # 80016f88 <itable>
    80002db6:	00003097          	auipc	ra,0x3
    80002dba:	50a080e7          	jalr	1290(ra) # 800062c0 <release>
}
    80002dbe:	60e2                	ld	ra,24(sp)
    80002dc0:	6442                	ld	s0,16(sp)
    80002dc2:	64a2                	ld	s1,8(sp)
    80002dc4:	6902                	ld	s2,0(sp)
    80002dc6:	6105                	addi	sp,sp,32
    80002dc8:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dca:	40bc                	lw	a5,64(s1)
    80002dcc:	dff1                	beqz	a5,80002da8 <iput+0x26>
    80002dce:	04a49783          	lh	a5,74(s1)
    80002dd2:	fbf9                	bnez	a5,80002da8 <iput+0x26>
    acquiresleep(&ip->lock);
    80002dd4:	01048913          	addi	s2,s1,16
    80002dd8:	854a                	mv	a0,s2
    80002dda:	00001097          	auipc	ra,0x1
    80002dde:	aa8080e7          	jalr	-1368(ra) # 80003882 <acquiresleep>
    release(&itable.lock);
    80002de2:	00014517          	auipc	a0,0x14
    80002de6:	1a650513          	addi	a0,a0,422 # 80016f88 <itable>
    80002dea:	00003097          	auipc	ra,0x3
    80002dee:	4d6080e7          	jalr	1238(ra) # 800062c0 <release>
    itrunc(ip);
    80002df2:	8526                	mv	a0,s1
    80002df4:	00000097          	auipc	ra,0x0
    80002df8:	ee2080e7          	jalr	-286(ra) # 80002cd6 <itrunc>
    ip->type = 0;
    80002dfc:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e00:	8526                	mv	a0,s1
    80002e02:	00000097          	auipc	ra,0x0
    80002e06:	cfc080e7          	jalr	-772(ra) # 80002afe <iupdate>
    ip->valid = 0;
    80002e0a:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e0e:	854a                	mv	a0,s2
    80002e10:	00001097          	auipc	ra,0x1
    80002e14:	ac8080e7          	jalr	-1336(ra) # 800038d8 <releasesleep>
    acquire(&itable.lock);
    80002e18:	00014517          	auipc	a0,0x14
    80002e1c:	17050513          	addi	a0,a0,368 # 80016f88 <itable>
    80002e20:	00003097          	auipc	ra,0x3
    80002e24:	3ec080e7          	jalr	1004(ra) # 8000620c <acquire>
    80002e28:	b741                	j	80002da8 <iput+0x26>

0000000080002e2a <iunlockput>:
{
    80002e2a:	1101                	addi	sp,sp,-32
    80002e2c:	ec06                	sd	ra,24(sp)
    80002e2e:	e822                	sd	s0,16(sp)
    80002e30:	e426                	sd	s1,8(sp)
    80002e32:	1000                	addi	s0,sp,32
    80002e34:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e36:	00000097          	auipc	ra,0x0
    80002e3a:	e54080e7          	jalr	-428(ra) # 80002c8a <iunlock>
  iput(ip);
    80002e3e:	8526                	mv	a0,s1
    80002e40:	00000097          	auipc	ra,0x0
    80002e44:	f42080e7          	jalr	-190(ra) # 80002d82 <iput>
}
    80002e48:	60e2                	ld	ra,24(sp)
    80002e4a:	6442                	ld	s0,16(sp)
    80002e4c:	64a2                	ld	s1,8(sp)
    80002e4e:	6105                	addi	sp,sp,32
    80002e50:	8082                	ret

0000000080002e52 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e52:	1141                	addi	sp,sp,-16
    80002e54:	e422                	sd	s0,8(sp)
    80002e56:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e58:	411c                	lw	a5,0(a0)
    80002e5a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e5c:	415c                	lw	a5,4(a0)
    80002e5e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e60:	04451783          	lh	a5,68(a0)
    80002e64:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e68:	04a51783          	lh	a5,74(a0)
    80002e6c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e70:	04c56783          	lwu	a5,76(a0)
    80002e74:	e99c                	sd	a5,16(a1)
}
    80002e76:	6422                	ld	s0,8(sp)
    80002e78:	0141                	addi	sp,sp,16
    80002e7a:	8082                	ret

0000000080002e7c <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e7c:	457c                	lw	a5,76(a0)
    80002e7e:	0ed7e963          	bltu	a5,a3,80002f70 <readi+0xf4>
{
    80002e82:	7159                	addi	sp,sp,-112
    80002e84:	f486                	sd	ra,104(sp)
    80002e86:	f0a2                	sd	s0,96(sp)
    80002e88:	eca6                	sd	s1,88(sp)
    80002e8a:	e8ca                	sd	s2,80(sp)
    80002e8c:	e4ce                	sd	s3,72(sp)
    80002e8e:	e0d2                	sd	s4,64(sp)
    80002e90:	fc56                	sd	s5,56(sp)
    80002e92:	f85a                	sd	s6,48(sp)
    80002e94:	f45e                	sd	s7,40(sp)
    80002e96:	f062                	sd	s8,32(sp)
    80002e98:	ec66                	sd	s9,24(sp)
    80002e9a:	e86a                	sd	s10,16(sp)
    80002e9c:	e46e                	sd	s11,8(sp)
    80002e9e:	1880                	addi	s0,sp,112
    80002ea0:	8b2a                	mv	s6,a0
    80002ea2:	8bae                	mv	s7,a1
    80002ea4:	8a32                	mv	s4,a2
    80002ea6:	84b6                	mv	s1,a3
    80002ea8:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002eaa:	9f35                	addw	a4,a4,a3
    return 0;
    80002eac:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002eae:	0ad76063          	bltu	a4,a3,80002f4e <readi+0xd2>
  if(off + n > ip->size)
    80002eb2:	00e7f463          	bgeu	a5,a4,80002eba <readi+0x3e>
    n = ip->size - off;
    80002eb6:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002eba:	0a0a8963          	beqz	s5,80002f6c <readi+0xf0>
    80002ebe:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ec0:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ec4:	5c7d                	li	s8,-1
    80002ec6:	a82d                	j	80002f00 <readi+0x84>
    80002ec8:	020d1d93          	slli	s11,s10,0x20
    80002ecc:	020ddd93          	srli	s11,s11,0x20
    80002ed0:	05890613          	addi	a2,s2,88
    80002ed4:	86ee                	mv	a3,s11
    80002ed6:	963a                	add	a2,a2,a4
    80002ed8:	85d2                	mv	a1,s4
    80002eda:	855e                	mv	a0,s7
    80002edc:	fffff097          	auipc	ra,0xfffff
    80002ee0:	aa4080e7          	jalr	-1372(ra) # 80001980 <either_copyout>
    80002ee4:	05850d63          	beq	a0,s8,80002f3e <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ee8:	854a                	mv	a0,s2
    80002eea:	fffff097          	auipc	ra,0xfffff
    80002eee:	5f4080e7          	jalr	1524(ra) # 800024de <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ef2:	013d09bb          	addw	s3,s10,s3
    80002ef6:	009d04bb          	addw	s1,s10,s1
    80002efa:	9a6e                	add	s4,s4,s11
    80002efc:	0559f763          	bgeu	s3,s5,80002f4a <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002f00:	00a4d59b          	srliw	a1,s1,0xa
    80002f04:	855a                	mv	a0,s6
    80002f06:	00000097          	auipc	ra,0x0
    80002f0a:	8a2080e7          	jalr	-1886(ra) # 800027a8 <bmap>
    80002f0e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f12:	cd85                	beqz	a1,80002f4a <readi+0xce>
    bp = bread(ip->dev, addr);
    80002f14:	000b2503          	lw	a0,0(s6)
    80002f18:	fffff097          	auipc	ra,0xfffff
    80002f1c:	496080e7          	jalr	1174(ra) # 800023ae <bread>
    80002f20:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f22:	3ff4f713          	andi	a4,s1,1023
    80002f26:	40ec87bb          	subw	a5,s9,a4
    80002f2a:	413a86bb          	subw	a3,s5,s3
    80002f2e:	8d3e                	mv	s10,a5
    80002f30:	2781                	sext.w	a5,a5
    80002f32:	0006861b          	sext.w	a2,a3
    80002f36:	f8f679e3          	bgeu	a2,a5,80002ec8 <readi+0x4c>
    80002f3a:	8d36                	mv	s10,a3
    80002f3c:	b771                	j	80002ec8 <readi+0x4c>
      brelse(bp);
    80002f3e:	854a                	mv	a0,s2
    80002f40:	fffff097          	auipc	ra,0xfffff
    80002f44:	59e080e7          	jalr	1438(ra) # 800024de <brelse>
      tot = -1;
    80002f48:	59fd                	li	s3,-1
  }
  return tot;
    80002f4a:	0009851b          	sext.w	a0,s3
}
    80002f4e:	70a6                	ld	ra,104(sp)
    80002f50:	7406                	ld	s0,96(sp)
    80002f52:	64e6                	ld	s1,88(sp)
    80002f54:	6946                	ld	s2,80(sp)
    80002f56:	69a6                	ld	s3,72(sp)
    80002f58:	6a06                	ld	s4,64(sp)
    80002f5a:	7ae2                	ld	s5,56(sp)
    80002f5c:	7b42                	ld	s6,48(sp)
    80002f5e:	7ba2                	ld	s7,40(sp)
    80002f60:	7c02                	ld	s8,32(sp)
    80002f62:	6ce2                	ld	s9,24(sp)
    80002f64:	6d42                	ld	s10,16(sp)
    80002f66:	6da2                	ld	s11,8(sp)
    80002f68:	6165                	addi	sp,sp,112
    80002f6a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f6c:	89d6                	mv	s3,s5
    80002f6e:	bff1                	j	80002f4a <readi+0xce>
    return 0;
    80002f70:	4501                	li	a0,0
}
    80002f72:	8082                	ret

0000000080002f74 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f74:	457c                	lw	a5,76(a0)
    80002f76:	10d7e863          	bltu	a5,a3,80003086 <writei+0x112>
{
    80002f7a:	7159                	addi	sp,sp,-112
    80002f7c:	f486                	sd	ra,104(sp)
    80002f7e:	f0a2                	sd	s0,96(sp)
    80002f80:	eca6                	sd	s1,88(sp)
    80002f82:	e8ca                	sd	s2,80(sp)
    80002f84:	e4ce                	sd	s3,72(sp)
    80002f86:	e0d2                	sd	s4,64(sp)
    80002f88:	fc56                	sd	s5,56(sp)
    80002f8a:	f85a                	sd	s6,48(sp)
    80002f8c:	f45e                	sd	s7,40(sp)
    80002f8e:	f062                	sd	s8,32(sp)
    80002f90:	ec66                	sd	s9,24(sp)
    80002f92:	e86a                	sd	s10,16(sp)
    80002f94:	e46e                	sd	s11,8(sp)
    80002f96:	1880                	addi	s0,sp,112
    80002f98:	8aaa                	mv	s5,a0
    80002f9a:	8bae                	mv	s7,a1
    80002f9c:	8a32                	mv	s4,a2
    80002f9e:	8936                	mv	s2,a3
    80002fa0:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002fa2:	00e687bb          	addw	a5,a3,a4
    80002fa6:	0ed7e263          	bltu	a5,a3,8000308a <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002faa:	00043737          	lui	a4,0x43
    80002fae:	0ef76063          	bltu	a4,a5,8000308e <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fb2:	0c0b0863          	beqz	s6,80003082 <writei+0x10e>
    80002fb6:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fb8:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002fbc:	5c7d                	li	s8,-1
    80002fbe:	a091                	j	80003002 <writei+0x8e>
    80002fc0:	020d1d93          	slli	s11,s10,0x20
    80002fc4:	020ddd93          	srli	s11,s11,0x20
    80002fc8:	05848513          	addi	a0,s1,88
    80002fcc:	86ee                	mv	a3,s11
    80002fce:	8652                	mv	a2,s4
    80002fd0:	85de                	mv	a1,s7
    80002fd2:	953a                	add	a0,a0,a4
    80002fd4:	fffff097          	auipc	ra,0xfffff
    80002fd8:	a02080e7          	jalr	-1534(ra) # 800019d6 <either_copyin>
    80002fdc:	07850263          	beq	a0,s8,80003040 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002fe0:	8526                	mv	a0,s1
    80002fe2:	00000097          	auipc	ra,0x0
    80002fe6:	780080e7          	jalr	1920(ra) # 80003762 <log_write>
    brelse(bp);
    80002fea:	8526                	mv	a0,s1
    80002fec:	fffff097          	auipc	ra,0xfffff
    80002ff0:	4f2080e7          	jalr	1266(ra) # 800024de <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ff4:	013d09bb          	addw	s3,s10,s3
    80002ff8:	012d093b          	addw	s2,s10,s2
    80002ffc:	9a6e                	add	s4,s4,s11
    80002ffe:	0569f663          	bgeu	s3,s6,8000304a <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003002:	00a9559b          	srliw	a1,s2,0xa
    80003006:	8556                	mv	a0,s5
    80003008:	fffff097          	auipc	ra,0xfffff
    8000300c:	7a0080e7          	jalr	1952(ra) # 800027a8 <bmap>
    80003010:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003014:	c99d                	beqz	a1,8000304a <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003016:	000aa503          	lw	a0,0(s5)
    8000301a:	fffff097          	auipc	ra,0xfffff
    8000301e:	394080e7          	jalr	916(ra) # 800023ae <bread>
    80003022:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003024:	3ff97713          	andi	a4,s2,1023
    80003028:	40ec87bb          	subw	a5,s9,a4
    8000302c:	413b06bb          	subw	a3,s6,s3
    80003030:	8d3e                	mv	s10,a5
    80003032:	2781                	sext.w	a5,a5
    80003034:	0006861b          	sext.w	a2,a3
    80003038:	f8f674e3          	bgeu	a2,a5,80002fc0 <writei+0x4c>
    8000303c:	8d36                	mv	s10,a3
    8000303e:	b749                	j	80002fc0 <writei+0x4c>
      brelse(bp);
    80003040:	8526                	mv	a0,s1
    80003042:	fffff097          	auipc	ra,0xfffff
    80003046:	49c080e7          	jalr	1180(ra) # 800024de <brelse>
  }

  if(off > ip->size)
    8000304a:	04caa783          	lw	a5,76(s5)
    8000304e:	0127f463          	bgeu	a5,s2,80003056 <writei+0xe2>
    ip->size = off;
    80003052:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003056:	8556                	mv	a0,s5
    80003058:	00000097          	auipc	ra,0x0
    8000305c:	aa6080e7          	jalr	-1370(ra) # 80002afe <iupdate>

  return tot;
    80003060:	0009851b          	sext.w	a0,s3
}
    80003064:	70a6                	ld	ra,104(sp)
    80003066:	7406                	ld	s0,96(sp)
    80003068:	64e6                	ld	s1,88(sp)
    8000306a:	6946                	ld	s2,80(sp)
    8000306c:	69a6                	ld	s3,72(sp)
    8000306e:	6a06                	ld	s4,64(sp)
    80003070:	7ae2                	ld	s5,56(sp)
    80003072:	7b42                	ld	s6,48(sp)
    80003074:	7ba2                	ld	s7,40(sp)
    80003076:	7c02                	ld	s8,32(sp)
    80003078:	6ce2                	ld	s9,24(sp)
    8000307a:	6d42                	ld	s10,16(sp)
    8000307c:	6da2                	ld	s11,8(sp)
    8000307e:	6165                	addi	sp,sp,112
    80003080:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003082:	89da                	mv	s3,s6
    80003084:	bfc9                	j	80003056 <writei+0xe2>
    return -1;
    80003086:	557d                	li	a0,-1
}
    80003088:	8082                	ret
    return -1;
    8000308a:	557d                	li	a0,-1
    8000308c:	bfe1                	j	80003064 <writei+0xf0>
    return -1;
    8000308e:	557d                	li	a0,-1
    80003090:	bfd1                	j	80003064 <writei+0xf0>

0000000080003092 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003092:	1141                	addi	sp,sp,-16
    80003094:	e406                	sd	ra,8(sp)
    80003096:	e022                	sd	s0,0(sp)
    80003098:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000309a:	4639                	li	a2,14
    8000309c:	ffffd097          	auipc	ra,0xffffd
    800030a0:	1b4080e7          	jalr	436(ra) # 80000250 <strncmp>
}
    800030a4:	60a2                	ld	ra,8(sp)
    800030a6:	6402                	ld	s0,0(sp)
    800030a8:	0141                	addi	sp,sp,16
    800030aa:	8082                	ret

00000000800030ac <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030ac:	7139                	addi	sp,sp,-64
    800030ae:	fc06                	sd	ra,56(sp)
    800030b0:	f822                	sd	s0,48(sp)
    800030b2:	f426                	sd	s1,40(sp)
    800030b4:	f04a                	sd	s2,32(sp)
    800030b6:	ec4e                	sd	s3,24(sp)
    800030b8:	e852                	sd	s4,16(sp)
    800030ba:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030bc:	04451703          	lh	a4,68(a0)
    800030c0:	4785                	li	a5,1
    800030c2:	00f71a63          	bne	a4,a5,800030d6 <dirlookup+0x2a>
    800030c6:	892a                	mv	s2,a0
    800030c8:	89ae                	mv	s3,a1
    800030ca:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030cc:	457c                	lw	a5,76(a0)
    800030ce:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030d0:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030d2:	e79d                	bnez	a5,80003100 <dirlookup+0x54>
    800030d4:	a8a5                	j	8000314c <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030d6:	00005517          	auipc	a0,0x5
    800030da:	61a50513          	addi	a0,a0,1562 # 800086f0 <syscallnames+0x1a8>
    800030de:	00003097          	auipc	ra,0x3
    800030e2:	be4080e7          	jalr	-1052(ra) # 80005cc2 <panic>
      panic("dirlookup read");
    800030e6:	00005517          	auipc	a0,0x5
    800030ea:	62250513          	addi	a0,a0,1570 # 80008708 <syscallnames+0x1c0>
    800030ee:	00003097          	auipc	ra,0x3
    800030f2:	bd4080e7          	jalr	-1068(ra) # 80005cc2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030f6:	24c1                	addiw	s1,s1,16
    800030f8:	04c92783          	lw	a5,76(s2)
    800030fc:	04f4f763          	bgeu	s1,a5,8000314a <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003100:	4741                	li	a4,16
    80003102:	86a6                	mv	a3,s1
    80003104:	fc040613          	addi	a2,s0,-64
    80003108:	4581                	li	a1,0
    8000310a:	854a                	mv	a0,s2
    8000310c:	00000097          	auipc	ra,0x0
    80003110:	d70080e7          	jalr	-656(ra) # 80002e7c <readi>
    80003114:	47c1                	li	a5,16
    80003116:	fcf518e3          	bne	a0,a5,800030e6 <dirlookup+0x3a>
    if(de.inum == 0)
    8000311a:	fc045783          	lhu	a5,-64(s0)
    8000311e:	dfe1                	beqz	a5,800030f6 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003120:	fc240593          	addi	a1,s0,-62
    80003124:	854e                	mv	a0,s3
    80003126:	00000097          	auipc	ra,0x0
    8000312a:	f6c080e7          	jalr	-148(ra) # 80003092 <namecmp>
    8000312e:	f561                	bnez	a0,800030f6 <dirlookup+0x4a>
      if(poff)
    80003130:	000a0463          	beqz	s4,80003138 <dirlookup+0x8c>
        *poff = off;
    80003134:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003138:	fc045583          	lhu	a1,-64(s0)
    8000313c:	00092503          	lw	a0,0(s2)
    80003140:	fffff097          	auipc	ra,0xfffff
    80003144:	750080e7          	jalr	1872(ra) # 80002890 <iget>
    80003148:	a011                	j	8000314c <dirlookup+0xa0>
  return 0;
    8000314a:	4501                	li	a0,0
}
    8000314c:	70e2                	ld	ra,56(sp)
    8000314e:	7442                	ld	s0,48(sp)
    80003150:	74a2                	ld	s1,40(sp)
    80003152:	7902                	ld	s2,32(sp)
    80003154:	69e2                	ld	s3,24(sp)
    80003156:	6a42                	ld	s4,16(sp)
    80003158:	6121                	addi	sp,sp,64
    8000315a:	8082                	ret

000000008000315c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000315c:	711d                	addi	sp,sp,-96
    8000315e:	ec86                	sd	ra,88(sp)
    80003160:	e8a2                	sd	s0,80(sp)
    80003162:	e4a6                	sd	s1,72(sp)
    80003164:	e0ca                	sd	s2,64(sp)
    80003166:	fc4e                	sd	s3,56(sp)
    80003168:	f852                	sd	s4,48(sp)
    8000316a:	f456                	sd	s5,40(sp)
    8000316c:	f05a                	sd	s6,32(sp)
    8000316e:	ec5e                	sd	s7,24(sp)
    80003170:	e862                	sd	s8,16(sp)
    80003172:	e466                	sd	s9,8(sp)
    80003174:	1080                	addi	s0,sp,96
    80003176:	84aa                	mv	s1,a0
    80003178:	8b2e                	mv	s6,a1
    8000317a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000317c:	00054703          	lbu	a4,0(a0)
    80003180:	02f00793          	li	a5,47
    80003184:	02f70363          	beq	a4,a5,800031aa <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003188:	ffffe097          	auipc	ra,0xffffe
    8000318c:	cd0080e7          	jalr	-816(ra) # 80000e58 <myproc>
    80003190:	15053503          	ld	a0,336(a0)
    80003194:	00000097          	auipc	ra,0x0
    80003198:	9f6080e7          	jalr	-1546(ra) # 80002b8a <idup>
    8000319c:	89aa                	mv	s3,a0
  while(*path == '/')
    8000319e:	02f00913          	li	s2,47
  len = path - s;
    800031a2:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800031a4:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031a6:	4c05                	li	s8,1
    800031a8:	a865                	j	80003260 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800031aa:	4585                	li	a1,1
    800031ac:	4505                	li	a0,1
    800031ae:	fffff097          	auipc	ra,0xfffff
    800031b2:	6e2080e7          	jalr	1762(ra) # 80002890 <iget>
    800031b6:	89aa                	mv	s3,a0
    800031b8:	b7dd                	j	8000319e <namex+0x42>
      iunlockput(ip);
    800031ba:	854e                	mv	a0,s3
    800031bc:	00000097          	auipc	ra,0x0
    800031c0:	c6e080e7          	jalr	-914(ra) # 80002e2a <iunlockput>
      return 0;
    800031c4:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031c6:	854e                	mv	a0,s3
    800031c8:	60e6                	ld	ra,88(sp)
    800031ca:	6446                	ld	s0,80(sp)
    800031cc:	64a6                	ld	s1,72(sp)
    800031ce:	6906                	ld	s2,64(sp)
    800031d0:	79e2                	ld	s3,56(sp)
    800031d2:	7a42                	ld	s4,48(sp)
    800031d4:	7aa2                	ld	s5,40(sp)
    800031d6:	7b02                	ld	s6,32(sp)
    800031d8:	6be2                	ld	s7,24(sp)
    800031da:	6c42                	ld	s8,16(sp)
    800031dc:	6ca2                	ld	s9,8(sp)
    800031de:	6125                	addi	sp,sp,96
    800031e0:	8082                	ret
      iunlock(ip);
    800031e2:	854e                	mv	a0,s3
    800031e4:	00000097          	auipc	ra,0x0
    800031e8:	aa6080e7          	jalr	-1370(ra) # 80002c8a <iunlock>
      return ip;
    800031ec:	bfe9                	j	800031c6 <namex+0x6a>
      iunlockput(ip);
    800031ee:	854e                	mv	a0,s3
    800031f0:	00000097          	auipc	ra,0x0
    800031f4:	c3a080e7          	jalr	-966(ra) # 80002e2a <iunlockput>
      return 0;
    800031f8:	89d2                	mv	s3,s4
    800031fa:	b7f1                	j	800031c6 <namex+0x6a>
  len = path - s;
    800031fc:	40b48633          	sub	a2,s1,a1
    80003200:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003204:	094cd463          	bge	s9,s4,8000328c <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003208:	4639                	li	a2,14
    8000320a:	8556                	mv	a0,s5
    8000320c:	ffffd097          	auipc	ra,0xffffd
    80003210:	fcc080e7          	jalr	-52(ra) # 800001d8 <memmove>
  while(*path == '/')
    80003214:	0004c783          	lbu	a5,0(s1)
    80003218:	01279763          	bne	a5,s2,80003226 <namex+0xca>
    path++;
    8000321c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000321e:	0004c783          	lbu	a5,0(s1)
    80003222:	ff278de3          	beq	a5,s2,8000321c <namex+0xc0>
    ilock(ip);
    80003226:	854e                	mv	a0,s3
    80003228:	00000097          	auipc	ra,0x0
    8000322c:	9a0080e7          	jalr	-1632(ra) # 80002bc8 <ilock>
    if(ip->type != T_DIR){
    80003230:	04499783          	lh	a5,68(s3)
    80003234:	f98793e3          	bne	a5,s8,800031ba <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003238:	000b0563          	beqz	s6,80003242 <namex+0xe6>
    8000323c:	0004c783          	lbu	a5,0(s1)
    80003240:	d3cd                	beqz	a5,800031e2 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003242:	865e                	mv	a2,s7
    80003244:	85d6                	mv	a1,s5
    80003246:	854e                	mv	a0,s3
    80003248:	00000097          	auipc	ra,0x0
    8000324c:	e64080e7          	jalr	-412(ra) # 800030ac <dirlookup>
    80003250:	8a2a                	mv	s4,a0
    80003252:	dd51                	beqz	a0,800031ee <namex+0x92>
    iunlockput(ip);
    80003254:	854e                	mv	a0,s3
    80003256:	00000097          	auipc	ra,0x0
    8000325a:	bd4080e7          	jalr	-1068(ra) # 80002e2a <iunlockput>
    ip = next;
    8000325e:	89d2                	mv	s3,s4
  while(*path == '/')
    80003260:	0004c783          	lbu	a5,0(s1)
    80003264:	05279763          	bne	a5,s2,800032b2 <namex+0x156>
    path++;
    80003268:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000326a:	0004c783          	lbu	a5,0(s1)
    8000326e:	ff278de3          	beq	a5,s2,80003268 <namex+0x10c>
  if(*path == 0)
    80003272:	c79d                	beqz	a5,800032a0 <namex+0x144>
    path++;
    80003274:	85a6                	mv	a1,s1
  len = path - s;
    80003276:	8a5e                	mv	s4,s7
    80003278:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000327a:	01278963          	beq	a5,s2,8000328c <namex+0x130>
    8000327e:	dfbd                	beqz	a5,800031fc <namex+0xa0>
    path++;
    80003280:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003282:	0004c783          	lbu	a5,0(s1)
    80003286:	ff279ce3          	bne	a5,s2,8000327e <namex+0x122>
    8000328a:	bf8d                	j	800031fc <namex+0xa0>
    memmove(name, s, len);
    8000328c:	2601                	sext.w	a2,a2
    8000328e:	8556                	mv	a0,s5
    80003290:	ffffd097          	auipc	ra,0xffffd
    80003294:	f48080e7          	jalr	-184(ra) # 800001d8 <memmove>
    name[len] = 0;
    80003298:	9a56                	add	s4,s4,s5
    8000329a:	000a0023          	sb	zero,0(s4)
    8000329e:	bf9d                	j	80003214 <namex+0xb8>
  if(nameiparent){
    800032a0:	f20b03e3          	beqz	s6,800031c6 <namex+0x6a>
    iput(ip);
    800032a4:	854e                	mv	a0,s3
    800032a6:	00000097          	auipc	ra,0x0
    800032aa:	adc080e7          	jalr	-1316(ra) # 80002d82 <iput>
    return 0;
    800032ae:	4981                	li	s3,0
    800032b0:	bf19                	j	800031c6 <namex+0x6a>
  if(*path == 0)
    800032b2:	d7fd                	beqz	a5,800032a0 <namex+0x144>
  while(*path != '/' && *path != 0)
    800032b4:	0004c783          	lbu	a5,0(s1)
    800032b8:	85a6                	mv	a1,s1
    800032ba:	b7d1                	j	8000327e <namex+0x122>

00000000800032bc <dirlink>:
{
    800032bc:	7139                	addi	sp,sp,-64
    800032be:	fc06                	sd	ra,56(sp)
    800032c0:	f822                	sd	s0,48(sp)
    800032c2:	f426                	sd	s1,40(sp)
    800032c4:	f04a                	sd	s2,32(sp)
    800032c6:	ec4e                	sd	s3,24(sp)
    800032c8:	e852                	sd	s4,16(sp)
    800032ca:	0080                	addi	s0,sp,64
    800032cc:	892a                	mv	s2,a0
    800032ce:	8a2e                	mv	s4,a1
    800032d0:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032d2:	4601                	li	a2,0
    800032d4:	00000097          	auipc	ra,0x0
    800032d8:	dd8080e7          	jalr	-552(ra) # 800030ac <dirlookup>
    800032dc:	e93d                	bnez	a0,80003352 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032de:	04c92483          	lw	s1,76(s2)
    800032e2:	c49d                	beqz	s1,80003310 <dirlink+0x54>
    800032e4:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032e6:	4741                	li	a4,16
    800032e8:	86a6                	mv	a3,s1
    800032ea:	fc040613          	addi	a2,s0,-64
    800032ee:	4581                	li	a1,0
    800032f0:	854a                	mv	a0,s2
    800032f2:	00000097          	auipc	ra,0x0
    800032f6:	b8a080e7          	jalr	-1142(ra) # 80002e7c <readi>
    800032fa:	47c1                	li	a5,16
    800032fc:	06f51163          	bne	a0,a5,8000335e <dirlink+0xa2>
    if(de.inum == 0)
    80003300:	fc045783          	lhu	a5,-64(s0)
    80003304:	c791                	beqz	a5,80003310 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003306:	24c1                	addiw	s1,s1,16
    80003308:	04c92783          	lw	a5,76(s2)
    8000330c:	fcf4ede3          	bltu	s1,a5,800032e6 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003310:	4639                	li	a2,14
    80003312:	85d2                	mv	a1,s4
    80003314:	fc240513          	addi	a0,s0,-62
    80003318:	ffffd097          	auipc	ra,0xffffd
    8000331c:	f74080e7          	jalr	-140(ra) # 8000028c <strncpy>
  de.inum = inum;
    80003320:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003324:	4741                	li	a4,16
    80003326:	86a6                	mv	a3,s1
    80003328:	fc040613          	addi	a2,s0,-64
    8000332c:	4581                	li	a1,0
    8000332e:	854a                	mv	a0,s2
    80003330:	00000097          	auipc	ra,0x0
    80003334:	c44080e7          	jalr	-956(ra) # 80002f74 <writei>
    80003338:	1541                	addi	a0,a0,-16
    8000333a:	00a03533          	snez	a0,a0
    8000333e:	40a00533          	neg	a0,a0
}
    80003342:	70e2                	ld	ra,56(sp)
    80003344:	7442                	ld	s0,48(sp)
    80003346:	74a2                	ld	s1,40(sp)
    80003348:	7902                	ld	s2,32(sp)
    8000334a:	69e2                	ld	s3,24(sp)
    8000334c:	6a42                	ld	s4,16(sp)
    8000334e:	6121                	addi	sp,sp,64
    80003350:	8082                	ret
    iput(ip);
    80003352:	00000097          	auipc	ra,0x0
    80003356:	a30080e7          	jalr	-1488(ra) # 80002d82 <iput>
    return -1;
    8000335a:	557d                	li	a0,-1
    8000335c:	b7dd                	j	80003342 <dirlink+0x86>
      panic("dirlink read");
    8000335e:	00005517          	auipc	a0,0x5
    80003362:	3ba50513          	addi	a0,a0,954 # 80008718 <syscallnames+0x1d0>
    80003366:	00003097          	auipc	ra,0x3
    8000336a:	95c080e7          	jalr	-1700(ra) # 80005cc2 <panic>

000000008000336e <namei>:

struct inode*
namei(char *path)
{
    8000336e:	1101                	addi	sp,sp,-32
    80003370:	ec06                	sd	ra,24(sp)
    80003372:	e822                	sd	s0,16(sp)
    80003374:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003376:	fe040613          	addi	a2,s0,-32
    8000337a:	4581                	li	a1,0
    8000337c:	00000097          	auipc	ra,0x0
    80003380:	de0080e7          	jalr	-544(ra) # 8000315c <namex>
}
    80003384:	60e2                	ld	ra,24(sp)
    80003386:	6442                	ld	s0,16(sp)
    80003388:	6105                	addi	sp,sp,32
    8000338a:	8082                	ret

000000008000338c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000338c:	1141                	addi	sp,sp,-16
    8000338e:	e406                	sd	ra,8(sp)
    80003390:	e022                	sd	s0,0(sp)
    80003392:	0800                	addi	s0,sp,16
    80003394:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003396:	4585                	li	a1,1
    80003398:	00000097          	auipc	ra,0x0
    8000339c:	dc4080e7          	jalr	-572(ra) # 8000315c <namex>
}
    800033a0:	60a2                	ld	ra,8(sp)
    800033a2:	6402                	ld	s0,0(sp)
    800033a4:	0141                	addi	sp,sp,16
    800033a6:	8082                	ret

00000000800033a8 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033a8:	1101                	addi	sp,sp,-32
    800033aa:	ec06                	sd	ra,24(sp)
    800033ac:	e822                	sd	s0,16(sp)
    800033ae:	e426                	sd	s1,8(sp)
    800033b0:	e04a                	sd	s2,0(sp)
    800033b2:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033b4:	00015917          	auipc	s2,0x15
    800033b8:	67c90913          	addi	s2,s2,1660 # 80018a30 <log>
    800033bc:	01892583          	lw	a1,24(s2)
    800033c0:	02892503          	lw	a0,40(s2)
    800033c4:	fffff097          	auipc	ra,0xfffff
    800033c8:	fea080e7          	jalr	-22(ra) # 800023ae <bread>
    800033cc:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033ce:	02c92683          	lw	a3,44(s2)
    800033d2:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033d4:	02d05763          	blez	a3,80003402 <write_head+0x5a>
    800033d8:	00015797          	auipc	a5,0x15
    800033dc:	68878793          	addi	a5,a5,1672 # 80018a60 <log+0x30>
    800033e0:	05c50713          	addi	a4,a0,92
    800033e4:	36fd                	addiw	a3,a3,-1
    800033e6:	1682                	slli	a3,a3,0x20
    800033e8:	9281                	srli	a3,a3,0x20
    800033ea:	068a                	slli	a3,a3,0x2
    800033ec:	00015617          	auipc	a2,0x15
    800033f0:	67860613          	addi	a2,a2,1656 # 80018a64 <log+0x34>
    800033f4:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800033f6:	4390                	lw	a2,0(a5)
    800033f8:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800033fa:	0791                	addi	a5,a5,4
    800033fc:	0711                	addi	a4,a4,4
    800033fe:	fed79ce3          	bne	a5,a3,800033f6 <write_head+0x4e>
  }
  bwrite(buf);
    80003402:	8526                	mv	a0,s1
    80003404:	fffff097          	auipc	ra,0xfffff
    80003408:	09c080e7          	jalr	156(ra) # 800024a0 <bwrite>
  brelse(buf);
    8000340c:	8526                	mv	a0,s1
    8000340e:	fffff097          	auipc	ra,0xfffff
    80003412:	0d0080e7          	jalr	208(ra) # 800024de <brelse>
}
    80003416:	60e2                	ld	ra,24(sp)
    80003418:	6442                	ld	s0,16(sp)
    8000341a:	64a2                	ld	s1,8(sp)
    8000341c:	6902                	ld	s2,0(sp)
    8000341e:	6105                	addi	sp,sp,32
    80003420:	8082                	ret

0000000080003422 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003422:	00015797          	auipc	a5,0x15
    80003426:	63a7a783          	lw	a5,1594(a5) # 80018a5c <log+0x2c>
    8000342a:	0af05d63          	blez	a5,800034e4 <install_trans+0xc2>
{
    8000342e:	7139                	addi	sp,sp,-64
    80003430:	fc06                	sd	ra,56(sp)
    80003432:	f822                	sd	s0,48(sp)
    80003434:	f426                	sd	s1,40(sp)
    80003436:	f04a                	sd	s2,32(sp)
    80003438:	ec4e                	sd	s3,24(sp)
    8000343a:	e852                	sd	s4,16(sp)
    8000343c:	e456                	sd	s5,8(sp)
    8000343e:	e05a                	sd	s6,0(sp)
    80003440:	0080                	addi	s0,sp,64
    80003442:	8b2a                	mv	s6,a0
    80003444:	00015a97          	auipc	s5,0x15
    80003448:	61ca8a93          	addi	s5,s5,1564 # 80018a60 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000344c:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000344e:	00015997          	auipc	s3,0x15
    80003452:	5e298993          	addi	s3,s3,1506 # 80018a30 <log>
    80003456:	a035                	j	80003482 <install_trans+0x60>
      bunpin(dbuf);
    80003458:	8526                	mv	a0,s1
    8000345a:	fffff097          	auipc	ra,0xfffff
    8000345e:	15e080e7          	jalr	350(ra) # 800025b8 <bunpin>
    brelse(lbuf);
    80003462:	854a                	mv	a0,s2
    80003464:	fffff097          	auipc	ra,0xfffff
    80003468:	07a080e7          	jalr	122(ra) # 800024de <brelse>
    brelse(dbuf);
    8000346c:	8526                	mv	a0,s1
    8000346e:	fffff097          	auipc	ra,0xfffff
    80003472:	070080e7          	jalr	112(ra) # 800024de <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003476:	2a05                	addiw	s4,s4,1
    80003478:	0a91                	addi	s5,s5,4
    8000347a:	02c9a783          	lw	a5,44(s3)
    8000347e:	04fa5963          	bge	s4,a5,800034d0 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003482:	0189a583          	lw	a1,24(s3)
    80003486:	014585bb          	addw	a1,a1,s4
    8000348a:	2585                	addiw	a1,a1,1
    8000348c:	0289a503          	lw	a0,40(s3)
    80003490:	fffff097          	auipc	ra,0xfffff
    80003494:	f1e080e7          	jalr	-226(ra) # 800023ae <bread>
    80003498:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000349a:	000aa583          	lw	a1,0(s5)
    8000349e:	0289a503          	lw	a0,40(s3)
    800034a2:	fffff097          	auipc	ra,0xfffff
    800034a6:	f0c080e7          	jalr	-244(ra) # 800023ae <bread>
    800034aa:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034ac:	40000613          	li	a2,1024
    800034b0:	05890593          	addi	a1,s2,88
    800034b4:	05850513          	addi	a0,a0,88
    800034b8:	ffffd097          	auipc	ra,0xffffd
    800034bc:	d20080e7          	jalr	-736(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    800034c0:	8526                	mv	a0,s1
    800034c2:	fffff097          	auipc	ra,0xfffff
    800034c6:	fde080e7          	jalr	-34(ra) # 800024a0 <bwrite>
    if(recovering == 0)
    800034ca:	f80b1ce3          	bnez	s6,80003462 <install_trans+0x40>
    800034ce:	b769                	j	80003458 <install_trans+0x36>
}
    800034d0:	70e2                	ld	ra,56(sp)
    800034d2:	7442                	ld	s0,48(sp)
    800034d4:	74a2                	ld	s1,40(sp)
    800034d6:	7902                	ld	s2,32(sp)
    800034d8:	69e2                	ld	s3,24(sp)
    800034da:	6a42                	ld	s4,16(sp)
    800034dc:	6aa2                	ld	s5,8(sp)
    800034de:	6b02                	ld	s6,0(sp)
    800034e0:	6121                	addi	sp,sp,64
    800034e2:	8082                	ret
    800034e4:	8082                	ret

00000000800034e6 <initlog>:
{
    800034e6:	7179                	addi	sp,sp,-48
    800034e8:	f406                	sd	ra,40(sp)
    800034ea:	f022                	sd	s0,32(sp)
    800034ec:	ec26                	sd	s1,24(sp)
    800034ee:	e84a                	sd	s2,16(sp)
    800034f0:	e44e                	sd	s3,8(sp)
    800034f2:	1800                	addi	s0,sp,48
    800034f4:	892a                	mv	s2,a0
    800034f6:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800034f8:	00015497          	auipc	s1,0x15
    800034fc:	53848493          	addi	s1,s1,1336 # 80018a30 <log>
    80003500:	00005597          	auipc	a1,0x5
    80003504:	22858593          	addi	a1,a1,552 # 80008728 <syscallnames+0x1e0>
    80003508:	8526                	mv	a0,s1
    8000350a:	00003097          	auipc	ra,0x3
    8000350e:	c72080e7          	jalr	-910(ra) # 8000617c <initlock>
  log.start = sb->logstart;
    80003512:	0149a583          	lw	a1,20(s3)
    80003516:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003518:	0109a783          	lw	a5,16(s3)
    8000351c:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000351e:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003522:	854a                	mv	a0,s2
    80003524:	fffff097          	auipc	ra,0xfffff
    80003528:	e8a080e7          	jalr	-374(ra) # 800023ae <bread>
  log.lh.n = lh->n;
    8000352c:	4d3c                	lw	a5,88(a0)
    8000352e:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003530:	02f05563          	blez	a5,8000355a <initlog+0x74>
    80003534:	05c50713          	addi	a4,a0,92
    80003538:	00015697          	auipc	a3,0x15
    8000353c:	52868693          	addi	a3,a3,1320 # 80018a60 <log+0x30>
    80003540:	37fd                	addiw	a5,a5,-1
    80003542:	1782                	slli	a5,a5,0x20
    80003544:	9381                	srli	a5,a5,0x20
    80003546:	078a                	slli	a5,a5,0x2
    80003548:	06050613          	addi	a2,a0,96
    8000354c:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    8000354e:	4310                	lw	a2,0(a4)
    80003550:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003552:	0711                	addi	a4,a4,4
    80003554:	0691                	addi	a3,a3,4
    80003556:	fef71ce3          	bne	a4,a5,8000354e <initlog+0x68>
  brelse(buf);
    8000355a:	fffff097          	auipc	ra,0xfffff
    8000355e:	f84080e7          	jalr	-124(ra) # 800024de <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003562:	4505                	li	a0,1
    80003564:	00000097          	auipc	ra,0x0
    80003568:	ebe080e7          	jalr	-322(ra) # 80003422 <install_trans>
  log.lh.n = 0;
    8000356c:	00015797          	auipc	a5,0x15
    80003570:	4e07a823          	sw	zero,1264(a5) # 80018a5c <log+0x2c>
  write_head(); // clear the log
    80003574:	00000097          	auipc	ra,0x0
    80003578:	e34080e7          	jalr	-460(ra) # 800033a8 <write_head>
}
    8000357c:	70a2                	ld	ra,40(sp)
    8000357e:	7402                	ld	s0,32(sp)
    80003580:	64e2                	ld	s1,24(sp)
    80003582:	6942                	ld	s2,16(sp)
    80003584:	69a2                	ld	s3,8(sp)
    80003586:	6145                	addi	sp,sp,48
    80003588:	8082                	ret

000000008000358a <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000358a:	1101                	addi	sp,sp,-32
    8000358c:	ec06                	sd	ra,24(sp)
    8000358e:	e822                	sd	s0,16(sp)
    80003590:	e426                	sd	s1,8(sp)
    80003592:	e04a                	sd	s2,0(sp)
    80003594:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003596:	00015517          	auipc	a0,0x15
    8000359a:	49a50513          	addi	a0,a0,1178 # 80018a30 <log>
    8000359e:	00003097          	auipc	ra,0x3
    800035a2:	c6e080e7          	jalr	-914(ra) # 8000620c <acquire>
  while(1){
    if(log.committing){
    800035a6:	00015497          	auipc	s1,0x15
    800035aa:	48a48493          	addi	s1,s1,1162 # 80018a30 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035ae:	4979                	li	s2,30
    800035b0:	a039                	j	800035be <begin_op+0x34>
      sleep(&log, &log.lock);
    800035b2:	85a6                	mv	a1,s1
    800035b4:	8526                	mv	a0,s1
    800035b6:	ffffe097          	auipc	ra,0xffffe
    800035ba:	fc2080e7          	jalr	-62(ra) # 80001578 <sleep>
    if(log.committing){
    800035be:	50dc                	lw	a5,36(s1)
    800035c0:	fbed                	bnez	a5,800035b2 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035c2:	509c                	lw	a5,32(s1)
    800035c4:	0017871b          	addiw	a4,a5,1
    800035c8:	0007069b          	sext.w	a3,a4
    800035cc:	0027179b          	slliw	a5,a4,0x2
    800035d0:	9fb9                	addw	a5,a5,a4
    800035d2:	0017979b          	slliw	a5,a5,0x1
    800035d6:	54d8                	lw	a4,44(s1)
    800035d8:	9fb9                	addw	a5,a5,a4
    800035da:	00f95963          	bge	s2,a5,800035ec <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035de:	85a6                	mv	a1,s1
    800035e0:	8526                	mv	a0,s1
    800035e2:	ffffe097          	auipc	ra,0xffffe
    800035e6:	f96080e7          	jalr	-106(ra) # 80001578 <sleep>
    800035ea:	bfd1                	j	800035be <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800035ec:	00015517          	auipc	a0,0x15
    800035f0:	44450513          	addi	a0,a0,1092 # 80018a30 <log>
    800035f4:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800035f6:	00003097          	auipc	ra,0x3
    800035fa:	cca080e7          	jalr	-822(ra) # 800062c0 <release>
      break;
    }
  }
}
    800035fe:	60e2                	ld	ra,24(sp)
    80003600:	6442                	ld	s0,16(sp)
    80003602:	64a2                	ld	s1,8(sp)
    80003604:	6902                	ld	s2,0(sp)
    80003606:	6105                	addi	sp,sp,32
    80003608:	8082                	ret

000000008000360a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000360a:	7139                	addi	sp,sp,-64
    8000360c:	fc06                	sd	ra,56(sp)
    8000360e:	f822                	sd	s0,48(sp)
    80003610:	f426                	sd	s1,40(sp)
    80003612:	f04a                	sd	s2,32(sp)
    80003614:	ec4e                	sd	s3,24(sp)
    80003616:	e852                	sd	s4,16(sp)
    80003618:	e456                	sd	s5,8(sp)
    8000361a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000361c:	00015497          	auipc	s1,0x15
    80003620:	41448493          	addi	s1,s1,1044 # 80018a30 <log>
    80003624:	8526                	mv	a0,s1
    80003626:	00003097          	auipc	ra,0x3
    8000362a:	be6080e7          	jalr	-1050(ra) # 8000620c <acquire>
  log.outstanding -= 1;
    8000362e:	509c                	lw	a5,32(s1)
    80003630:	37fd                	addiw	a5,a5,-1
    80003632:	0007891b          	sext.w	s2,a5
    80003636:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003638:	50dc                	lw	a5,36(s1)
    8000363a:	efb9                	bnez	a5,80003698 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000363c:	06091663          	bnez	s2,800036a8 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003640:	00015497          	auipc	s1,0x15
    80003644:	3f048493          	addi	s1,s1,1008 # 80018a30 <log>
    80003648:	4785                	li	a5,1
    8000364a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000364c:	8526                	mv	a0,s1
    8000364e:	00003097          	auipc	ra,0x3
    80003652:	c72080e7          	jalr	-910(ra) # 800062c0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003656:	54dc                	lw	a5,44(s1)
    80003658:	06f04763          	bgtz	a5,800036c6 <end_op+0xbc>
    acquire(&log.lock);
    8000365c:	00015497          	auipc	s1,0x15
    80003660:	3d448493          	addi	s1,s1,980 # 80018a30 <log>
    80003664:	8526                	mv	a0,s1
    80003666:	00003097          	auipc	ra,0x3
    8000366a:	ba6080e7          	jalr	-1114(ra) # 8000620c <acquire>
    log.committing = 0;
    8000366e:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003672:	8526                	mv	a0,s1
    80003674:	ffffe097          	auipc	ra,0xffffe
    80003678:	f68080e7          	jalr	-152(ra) # 800015dc <wakeup>
    release(&log.lock);
    8000367c:	8526                	mv	a0,s1
    8000367e:	00003097          	auipc	ra,0x3
    80003682:	c42080e7          	jalr	-958(ra) # 800062c0 <release>
}
    80003686:	70e2                	ld	ra,56(sp)
    80003688:	7442                	ld	s0,48(sp)
    8000368a:	74a2                	ld	s1,40(sp)
    8000368c:	7902                	ld	s2,32(sp)
    8000368e:	69e2                	ld	s3,24(sp)
    80003690:	6a42                	ld	s4,16(sp)
    80003692:	6aa2                	ld	s5,8(sp)
    80003694:	6121                	addi	sp,sp,64
    80003696:	8082                	ret
    panic("log.committing");
    80003698:	00005517          	auipc	a0,0x5
    8000369c:	09850513          	addi	a0,a0,152 # 80008730 <syscallnames+0x1e8>
    800036a0:	00002097          	auipc	ra,0x2
    800036a4:	622080e7          	jalr	1570(ra) # 80005cc2 <panic>
    wakeup(&log);
    800036a8:	00015497          	auipc	s1,0x15
    800036ac:	38848493          	addi	s1,s1,904 # 80018a30 <log>
    800036b0:	8526                	mv	a0,s1
    800036b2:	ffffe097          	auipc	ra,0xffffe
    800036b6:	f2a080e7          	jalr	-214(ra) # 800015dc <wakeup>
  release(&log.lock);
    800036ba:	8526                	mv	a0,s1
    800036bc:	00003097          	auipc	ra,0x3
    800036c0:	c04080e7          	jalr	-1020(ra) # 800062c0 <release>
  if(do_commit){
    800036c4:	b7c9                	j	80003686 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036c6:	00015a97          	auipc	s5,0x15
    800036ca:	39aa8a93          	addi	s5,s5,922 # 80018a60 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036ce:	00015a17          	auipc	s4,0x15
    800036d2:	362a0a13          	addi	s4,s4,866 # 80018a30 <log>
    800036d6:	018a2583          	lw	a1,24(s4)
    800036da:	012585bb          	addw	a1,a1,s2
    800036de:	2585                	addiw	a1,a1,1
    800036e0:	028a2503          	lw	a0,40(s4)
    800036e4:	fffff097          	auipc	ra,0xfffff
    800036e8:	cca080e7          	jalr	-822(ra) # 800023ae <bread>
    800036ec:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800036ee:	000aa583          	lw	a1,0(s5)
    800036f2:	028a2503          	lw	a0,40(s4)
    800036f6:	fffff097          	auipc	ra,0xfffff
    800036fa:	cb8080e7          	jalr	-840(ra) # 800023ae <bread>
    800036fe:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003700:	40000613          	li	a2,1024
    80003704:	05850593          	addi	a1,a0,88
    80003708:	05848513          	addi	a0,s1,88
    8000370c:	ffffd097          	auipc	ra,0xffffd
    80003710:	acc080e7          	jalr	-1332(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    80003714:	8526                	mv	a0,s1
    80003716:	fffff097          	auipc	ra,0xfffff
    8000371a:	d8a080e7          	jalr	-630(ra) # 800024a0 <bwrite>
    brelse(from);
    8000371e:	854e                	mv	a0,s3
    80003720:	fffff097          	auipc	ra,0xfffff
    80003724:	dbe080e7          	jalr	-578(ra) # 800024de <brelse>
    brelse(to);
    80003728:	8526                	mv	a0,s1
    8000372a:	fffff097          	auipc	ra,0xfffff
    8000372e:	db4080e7          	jalr	-588(ra) # 800024de <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003732:	2905                	addiw	s2,s2,1
    80003734:	0a91                	addi	s5,s5,4
    80003736:	02ca2783          	lw	a5,44(s4)
    8000373a:	f8f94ee3          	blt	s2,a5,800036d6 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000373e:	00000097          	auipc	ra,0x0
    80003742:	c6a080e7          	jalr	-918(ra) # 800033a8 <write_head>
    install_trans(0); // Now install writes to home locations
    80003746:	4501                	li	a0,0
    80003748:	00000097          	auipc	ra,0x0
    8000374c:	cda080e7          	jalr	-806(ra) # 80003422 <install_trans>
    log.lh.n = 0;
    80003750:	00015797          	auipc	a5,0x15
    80003754:	3007a623          	sw	zero,780(a5) # 80018a5c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003758:	00000097          	auipc	ra,0x0
    8000375c:	c50080e7          	jalr	-944(ra) # 800033a8 <write_head>
    80003760:	bdf5                	j	8000365c <end_op+0x52>

0000000080003762 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003762:	1101                	addi	sp,sp,-32
    80003764:	ec06                	sd	ra,24(sp)
    80003766:	e822                	sd	s0,16(sp)
    80003768:	e426                	sd	s1,8(sp)
    8000376a:	e04a                	sd	s2,0(sp)
    8000376c:	1000                	addi	s0,sp,32
    8000376e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003770:	00015917          	auipc	s2,0x15
    80003774:	2c090913          	addi	s2,s2,704 # 80018a30 <log>
    80003778:	854a                	mv	a0,s2
    8000377a:	00003097          	auipc	ra,0x3
    8000377e:	a92080e7          	jalr	-1390(ra) # 8000620c <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003782:	02c92603          	lw	a2,44(s2)
    80003786:	47f5                	li	a5,29
    80003788:	06c7c563          	blt	a5,a2,800037f2 <log_write+0x90>
    8000378c:	00015797          	auipc	a5,0x15
    80003790:	2c07a783          	lw	a5,704(a5) # 80018a4c <log+0x1c>
    80003794:	37fd                	addiw	a5,a5,-1
    80003796:	04f65e63          	bge	a2,a5,800037f2 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000379a:	00015797          	auipc	a5,0x15
    8000379e:	2b67a783          	lw	a5,694(a5) # 80018a50 <log+0x20>
    800037a2:	06f05063          	blez	a5,80003802 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037a6:	4781                	li	a5,0
    800037a8:	06c05563          	blez	a2,80003812 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037ac:	44cc                	lw	a1,12(s1)
    800037ae:	00015717          	auipc	a4,0x15
    800037b2:	2b270713          	addi	a4,a4,690 # 80018a60 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037b6:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037b8:	4314                	lw	a3,0(a4)
    800037ba:	04b68c63          	beq	a3,a1,80003812 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037be:	2785                	addiw	a5,a5,1
    800037c0:	0711                	addi	a4,a4,4
    800037c2:	fef61be3          	bne	a2,a5,800037b8 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037c6:	0621                	addi	a2,a2,8
    800037c8:	060a                	slli	a2,a2,0x2
    800037ca:	00015797          	auipc	a5,0x15
    800037ce:	26678793          	addi	a5,a5,614 # 80018a30 <log>
    800037d2:	963e                	add	a2,a2,a5
    800037d4:	44dc                	lw	a5,12(s1)
    800037d6:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037d8:	8526                	mv	a0,s1
    800037da:	fffff097          	auipc	ra,0xfffff
    800037de:	da2080e7          	jalr	-606(ra) # 8000257c <bpin>
    log.lh.n++;
    800037e2:	00015717          	auipc	a4,0x15
    800037e6:	24e70713          	addi	a4,a4,590 # 80018a30 <log>
    800037ea:	575c                	lw	a5,44(a4)
    800037ec:	2785                	addiw	a5,a5,1
    800037ee:	d75c                	sw	a5,44(a4)
    800037f0:	a835                	j	8000382c <log_write+0xca>
    panic("too big a transaction");
    800037f2:	00005517          	auipc	a0,0x5
    800037f6:	f4e50513          	addi	a0,a0,-178 # 80008740 <syscallnames+0x1f8>
    800037fa:	00002097          	auipc	ra,0x2
    800037fe:	4c8080e7          	jalr	1224(ra) # 80005cc2 <panic>
    panic("log_write outside of trans");
    80003802:	00005517          	auipc	a0,0x5
    80003806:	f5650513          	addi	a0,a0,-170 # 80008758 <syscallnames+0x210>
    8000380a:	00002097          	auipc	ra,0x2
    8000380e:	4b8080e7          	jalr	1208(ra) # 80005cc2 <panic>
  log.lh.block[i] = b->blockno;
    80003812:	00878713          	addi	a4,a5,8
    80003816:	00271693          	slli	a3,a4,0x2
    8000381a:	00015717          	auipc	a4,0x15
    8000381e:	21670713          	addi	a4,a4,534 # 80018a30 <log>
    80003822:	9736                	add	a4,a4,a3
    80003824:	44d4                	lw	a3,12(s1)
    80003826:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003828:	faf608e3          	beq	a2,a5,800037d8 <log_write+0x76>
  }
  release(&log.lock);
    8000382c:	00015517          	auipc	a0,0x15
    80003830:	20450513          	addi	a0,a0,516 # 80018a30 <log>
    80003834:	00003097          	auipc	ra,0x3
    80003838:	a8c080e7          	jalr	-1396(ra) # 800062c0 <release>
}
    8000383c:	60e2                	ld	ra,24(sp)
    8000383e:	6442                	ld	s0,16(sp)
    80003840:	64a2                	ld	s1,8(sp)
    80003842:	6902                	ld	s2,0(sp)
    80003844:	6105                	addi	sp,sp,32
    80003846:	8082                	ret

0000000080003848 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003848:	1101                	addi	sp,sp,-32
    8000384a:	ec06                	sd	ra,24(sp)
    8000384c:	e822                	sd	s0,16(sp)
    8000384e:	e426                	sd	s1,8(sp)
    80003850:	e04a                	sd	s2,0(sp)
    80003852:	1000                	addi	s0,sp,32
    80003854:	84aa                	mv	s1,a0
    80003856:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003858:	00005597          	auipc	a1,0x5
    8000385c:	f2058593          	addi	a1,a1,-224 # 80008778 <syscallnames+0x230>
    80003860:	0521                	addi	a0,a0,8
    80003862:	00003097          	auipc	ra,0x3
    80003866:	91a080e7          	jalr	-1766(ra) # 8000617c <initlock>
  lk->name = name;
    8000386a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000386e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003872:	0204a423          	sw	zero,40(s1)
}
    80003876:	60e2                	ld	ra,24(sp)
    80003878:	6442                	ld	s0,16(sp)
    8000387a:	64a2                	ld	s1,8(sp)
    8000387c:	6902                	ld	s2,0(sp)
    8000387e:	6105                	addi	sp,sp,32
    80003880:	8082                	ret

0000000080003882 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003882:	1101                	addi	sp,sp,-32
    80003884:	ec06                	sd	ra,24(sp)
    80003886:	e822                	sd	s0,16(sp)
    80003888:	e426                	sd	s1,8(sp)
    8000388a:	e04a                	sd	s2,0(sp)
    8000388c:	1000                	addi	s0,sp,32
    8000388e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003890:	00850913          	addi	s2,a0,8
    80003894:	854a                	mv	a0,s2
    80003896:	00003097          	auipc	ra,0x3
    8000389a:	976080e7          	jalr	-1674(ra) # 8000620c <acquire>
  while (lk->locked) {
    8000389e:	409c                	lw	a5,0(s1)
    800038a0:	cb89                	beqz	a5,800038b2 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038a2:	85ca                	mv	a1,s2
    800038a4:	8526                	mv	a0,s1
    800038a6:	ffffe097          	auipc	ra,0xffffe
    800038aa:	cd2080e7          	jalr	-814(ra) # 80001578 <sleep>
  while (lk->locked) {
    800038ae:	409c                	lw	a5,0(s1)
    800038b0:	fbed                	bnez	a5,800038a2 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038b2:	4785                	li	a5,1
    800038b4:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038b6:	ffffd097          	auipc	ra,0xffffd
    800038ba:	5a2080e7          	jalr	1442(ra) # 80000e58 <myproc>
    800038be:	591c                	lw	a5,48(a0)
    800038c0:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038c2:	854a                	mv	a0,s2
    800038c4:	00003097          	auipc	ra,0x3
    800038c8:	9fc080e7          	jalr	-1540(ra) # 800062c0 <release>
}
    800038cc:	60e2                	ld	ra,24(sp)
    800038ce:	6442                	ld	s0,16(sp)
    800038d0:	64a2                	ld	s1,8(sp)
    800038d2:	6902                	ld	s2,0(sp)
    800038d4:	6105                	addi	sp,sp,32
    800038d6:	8082                	ret

00000000800038d8 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038d8:	1101                	addi	sp,sp,-32
    800038da:	ec06                	sd	ra,24(sp)
    800038dc:	e822                	sd	s0,16(sp)
    800038de:	e426                	sd	s1,8(sp)
    800038e0:	e04a                	sd	s2,0(sp)
    800038e2:	1000                	addi	s0,sp,32
    800038e4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038e6:	00850913          	addi	s2,a0,8
    800038ea:	854a                	mv	a0,s2
    800038ec:	00003097          	auipc	ra,0x3
    800038f0:	920080e7          	jalr	-1760(ra) # 8000620c <acquire>
  lk->locked = 0;
    800038f4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038f8:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800038fc:	8526                	mv	a0,s1
    800038fe:	ffffe097          	auipc	ra,0xffffe
    80003902:	cde080e7          	jalr	-802(ra) # 800015dc <wakeup>
  release(&lk->lk);
    80003906:	854a                	mv	a0,s2
    80003908:	00003097          	auipc	ra,0x3
    8000390c:	9b8080e7          	jalr	-1608(ra) # 800062c0 <release>
}
    80003910:	60e2                	ld	ra,24(sp)
    80003912:	6442                	ld	s0,16(sp)
    80003914:	64a2                	ld	s1,8(sp)
    80003916:	6902                	ld	s2,0(sp)
    80003918:	6105                	addi	sp,sp,32
    8000391a:	8082                	ret

000000008000391c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000391c:	7179                	addi	sp,sp,-48
    8000391e:	f406                	sd	ra,40(sp)
    80003920:	f022                	sd	s0,32(sp)
    80003922:	ec26                	sd	s1,24(sp)
    80003924:	e84a                	sd	s2,16(sp)
    80003926:	e44e                	sd	s3,8(sp)
    80003928:	1800                	addi	s0,sp,48
    8000392a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000392c:	00850913          	addi	s2,a0,8
    80003930:	854a                	mv	a0,s2
    80003932:	00003097          	auipc	ra,0x3
    80003936:	8da080e7          	jalr	-1830(ra) # 8000620c <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000393a:	409c                	lw	a5,0(s1)
    8000393c:	ef99                	bnez	a5,8000395a <holdingsleep+0x3e>
    8000393e:	4481                	li	s1,0
  release(&lk->lk);
    80003940:	854a                	mv	a0,s2
    80003942:	00003097          	auipc	ra,0x3
    80003946:	97e080e7          	jalr	-1666(ra) # 800062c0 <release>
  return r;
}
    8000394a:	8526                	mv	a0,s1
    8000394c:	70a2                	ld	ra,40(sp)
    8000394e:	7402                	ld	s0,32(sp)
    80003950:	64e2                	ld	s1,24(sp)
    80003952:	6942                	ld	s2,16(sp)
    80003954:	69a2                	ld	s3,8(sp)
    80003956:	6145                	addi	sp,sp,48
    80003958:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000395a:	0284a983          	lw	s3,40(s1)
    8000395e:	ffffd097          	auipc	ra,0xffffd
    80003962:	4fa080e7          	jalr	1274(ra) # 80000e58 <myproc>
    80003966:	5904                	lw	s1,48(a0)
    80003968:	413484b3          	sub	s1,s1,s3
    8000396c:	0014b493          	seqz	s1,s1
    80003970:	bfc1                	j	80003940 <holdingsleep+0x24>

0000000080003972 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003972:	1141                	addi	sp,sp,-16
    80003974:	e406                	sd	ra,8(sp)
    80003976:	e022                	sd	s0,0(sp)
    80003978:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000397a:	00005597          	auipc	a1,0x5
    8000397e:	e0e58593          	addi	a1,a1,-498 # 80008788 <syscallnames+0x240>
    80003982:	00015517          	auipc	a0,0x15
    80003986:	1f650513          	addi	a0,a0,502 # 80018b78 <ftable>
    8000398a:	00002097          	auipc	ra,0x2
    8000398e:	7f2080e7          	jalr	2034(ra) # 8000617c <initlock>
}
    80003992:	60a2                	ld	ra,8(sp)
    80003994:	6402                	ld	s0,0(sp)
    80003996:	0141                	addi	sp,sp,16
    80003998:	8082                	ret

000000008000399a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000399a:	1101                	addi	sp,sp,-32
    8000399c:	ec06                	sd	ra,24(sp)
    8000399e:	e822                	sd	s0,16(sp)
    800039a0:	e426                	sd	s1,8(sp)
    800039a2:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039a4:	00015517          	auipc	a0,0x15
    800039a8:	1d450513          	addi	a0,a0,468 # 80018b78 <ftable>
    800039ac:	00003097          	auipc	ra,0x3
    800039b0:	860080e7          	jalr	-1952(ra) # 8000620c <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039b4:	00015497          	auipc	s1,0x15
    800039b8:	1dc48493          	addi	s1,s1,476 # 80018b90 <ftable+0x18>
    800039bc:	00016717          	auipc	a4,0x16
    800039c0:	17470713          	addi	a4,a4,372 # 80019b30 <disk>
    if(f->ref == 0){
    800039c4:	40dc                	lw	a5,4(s1)
    800039c6:	cf99                	beqz	a5,800039e4 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039c8:	02848493          	addi	s1,s1,40
    800039cc:	fee49ce3          	bne	s1,a4,800039c4 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039d0:	00015517          	auipc	a0,0x15
    800039d4:	1a850513          	addi	a0,a0,424 # 80018b78 <ftable>
    800039d8:	00003097          	auipc	ra,0x3
    800039dc:	8e8080e7          	jalr	-1816(ra) # 800062c0 <release>
  return 0;
    800039e0:	4481                	li	s1,0
    800039e2:	a819                	j	800039f8 <filealloc+0x5e>
      f->ref = 1;
    800039e4:	4785                	li	a5,1
    800039e6:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800039e8:	00015517          	auipc	a0,0x15
    800039ec:	19050513          	addi	a0,a0,400 # 80018b78 <ftable>
    800039f0:	00003097          	auipc	ra,0x3
    800039f4:	8d0080e7          	jalr	-1840(ra) # 800062c0 <release>
}
    800039f8:	8526                	mv	a0,s1
    800039fa:	60e2                	ld	ra,24(sp)
    800039fc:	6442                	ld	s0,16(sp)
    800039fe:	64a2                	ld	s1,8(sp)
    80003a00:	6105                	addi	sp,sp,32
    80003a02:	8082                	ret

0000000080003a04 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a04:	1101                	addi	sp,sp,-32
    80003a06:	ec06                	sd	ra,24(sp)
    80003a08:	e822                	sd	s0,16(sp)
    80003a0a:	e426                	sd	s1,8(sp)
    80003a0c:	1000                	addi	s0,sp,32
    80003a0e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a10:	00015517          	auipc	a0,0x15
    80003a14:	16850513          	addi	a0,a0,360 # 80018b78 <ftable>
    80003a18:	00002097          	auipc	ra,0x2
    80003a1c:	7f4080e7          	jalr	2036(ra) # 8000620c <acquire>
  if(f->ref < 1)
    80003a20:	40dc                	lw	a5,4(s1)
    80003a22:	02f05263          	blez	a5,80003a46 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a26:	2785                	addiw	a5,a5,1
    80003a28:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a2a:	00015517          	auipc	a0,0x15
    80003a2e:	14e50513          	addi	a0,a0,334 # 80018b78 <ftable>
    80003a32:	00003097          	auipc	ra,0x3
    80003a36:	88e080e7          	jalr	-1906(ra) # 800062c0 <release>
  return f;
}
    80003a3a:	8526                	mv	a0,s1
    80003a3c:	60e2                	ld	ra,24(sp)
    80003a3e:	6442                	ld	s0,16(sp)
    80003a40:	64a2                	ld	s1,8(sp)
    80003a42:	6105                	addi	sp,sp,32
    80003a44:	8082                	ret
    panic("filedup");
    80003a46:	00005517          	auipc	a0,0x5
    80003a4a:	d4a50513          	addi	a0,a0,-694 # 80008790 <syscallnames+0x248>
    80003a4e:	00002097          	auipc	ra,0x2
    80003a52:	274080e7          	jalr	628(ra) # 80005cc2 <panic>

0000000080003a56 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a56:	7139                	addi	sp,sp,-64
    80003a58:	fc06                	sd	ra,56(sp)
    80003a5a:	f822                	sd	s0,48(sp)
    80003a5c:	f426                	sd	s1,40(sp)
    80003a5e:	f04a                	sd	s2,32(sp)
    80003a60:	ec4e                	sd	s3,24(sp)
    80003a62:	e852                	sd	s4,16(sp)
    80003a64:	e456                	sd	s5,8(sp)
    80003a66:	0080                	addi	s0,sp,64
    80003a68:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a6a:	00015517          	auipc	a0,0x15
    80003a6e:	10e50513          	addi	a0,a0,270 # 80018b78 <ftable>
    80003a72:	00002097          	auipc	ra,0x2
    80003a76:	79a080e7          	jalr	1946(ra) # 8000620c <acquire>
  if(f->ref < 1)
    80003a7a:	40dc                	lw	a5,4(s1)
    80003a7c:	06f05163          	blez	a5,80003ade <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a80:	37fd                	addiw	a5,a5,-1
    80003a82:	0007871b          	sext.w	a4,a5
    80003a86:	c0dc                	sw	a5,4(s1)
    80003a88:	06e04363          	bgtz	a4,80003aee <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a8c:	0004a903          	lw	s2,0(s1)
    80003a90:	0094ca83          	lbu	s5,9(s1)
    80003a94:	0104ba03          	ld	s4,16(s1)
    80003a98:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003a9c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003aa0:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003aa4:	00015517          	auipc	a0,0x15
    80003aa8:	0d450513          	addi	a0,a0,212 # 80018b78 <ftable>
    80003aac:	00003097          	auipc	ra,0x3
    80003ab0:	814080e7          	jalr	-2028(ra) # 800062c0 <release>

  if(ff.type == FD_PIPE){
    80003ab4:	4785                	li	a5,1
    80003ab6:	04f90d63          	beq	s2,a5,80003b10 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003aba:	3979                	addiw	s2,s2,-2
    80003abc:	4785                	li	a5,1
    80003abe:	0527e063          	bltu	a5,s2,80003afe <fileclose+0xa8>
    begin_op();
    80003ac2:	00000097          	auipc	ra,0x0
    80003ac6:	ac8080e7          	jalr	-1336(ra) # 8000358a <begin_op>
    iput(ff.ip);
    80003aca:	854e                	mv	a0,s3
    80003acc:	fffff097          	auipc	ra,0xfffff
    80003ad0:	2b6080e7          	jalr	694(ra) # 80002d82 <iput>
    end_op();
    80003ad4:	00000097          	auipc	ra,0x0
    80003ad8:	b36080e7          	jalr	-1226(ra) # 8000360a <end_op>
    80003adc:	a00d                	j	80003afe <fileclose+0xa8>
    panic("fileclose");
    80003ade:	00005517          	auipc	a0,0x5
    80003ae2:	cba50513          	addi	a0,a0,-838 # 80008798 <syscallnames+0x250>
    80003ae6:	00002097          	auipc	ra,0x2
    80003aea:	1dc080e7          	jalr	476(ra) # 80005cc2 <panic>
    release(&ftable.lock);
    80003aee:	00015517          	auipc	a0,0x15
    80003af2:	08a50513          	addi	a0,a0,138 # 80018b78 <ftable>
    80003af6:	00002097          	auipc	ra,0x2
    80003afa:	7ca080e7          	jalr	1994(ra) # 800062c0 <release>
  }
}
    80003afe:	70e2                	ld	ra,56(sp)
    80003b00:	7442                	ld	s0,48(sp)
    80003b02:	74a2                	ld	s1,40(sp)
    80003b04:	7902                	ld	s2,32(sp)
    80003b06:	69e2                	ld	s3,24(sp)
    80003b08:	6a42                	ld	s4,16(sp)
    80003b0a:	6aa2                	ld	s5,8(sp)
    80003b0c:	6121                	addi	sp,sp,64
    80003b0e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b10:	85d6                	mv	a1,s5
    80003b12:	8552                	mv	a0,s4
    80003b14:	00000097          	auipc	ra,0x0
    80003b18:	34c080e7          	jalr	844(ra) # 80003e60 <pipeclose>
    80003b1c:	b7cd                	j	80003afe <fileclose+0xa8>

0000000080003b1e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b1e:	715d                	addi	sp,sp,-80
    80003b20:	e486                	sd	ra,72(sp)
    80003b22:	e0a2                	sd	s0,64(sp)
    80003b24:	fc26                	sd	s1,56(sp)
    80003b26:	f84a                	sd	s2,48(sp)
    80003b28:	f44e                	sd	s3,40(sp)
    80003b2a:	0880                	addi	s0,sp,80
    80003b2c:	84aa                	mv	s1,a0
    80003b2e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b30:	ffffd097          	auipc	ra,0xffffd
    80003b34:	328080e7          	jalr	808(ra) # 80000e58 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b38:	409c                	lw	a5,0(s1)
    80003b3a:	37f9                	addiw	a5,a5,-2
    80003b3c:	4705                	li	a4,1
    80003b3e:	04f76763          	bltu	a4,a5,80003b8c <filestat+0x6e>
    80003b42:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b44:	6c88                	ld	a0,24(s1)
    80003b46:	fffff097          	auipc	ra,0xfffff
    80003b4a:	082080e7          	jalr	130(ra) # 80002bc8 <ilock>
    stati(f->ip, &st);
    80003b4e:	fb840593          	addi	a1,s0,-72
    80003b52:	6c88                	ld	a0,24(s1)
    80003b54:	fffff097          	auipc	ra,0xfffff
    80003b58:	2fe080e7          	jalr	766(ra) # 80002e52 <stati>
    iunlock(f->ip);
    80003b5c:	6c88                	ld	a0,24(s1)
    80003b5e:	fffff097          	auipc	ra,0xfffff
    80003b62:	12c080e7          	jalr	300(ra) # 80002c8a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b66:	46e1                	li	a3,24
    80003b68:	fb840613          	addi	a2,s0,-72
    80003b6c:	85ce                	mv	a1,s3
    80003b6e:	05093503          	ld	a0,80(s2)
    80003b72:	ffffd097          	auipc	ra,0xffffd
    80003b76:	fa4080e7          	jalr	-92(ra) # 80000b16 <copyout>
    80003b7a:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b7e:	60a6                	ld	ra,72(sp)
    80003b80:	6406                	ld	s0,64(sp)
    80003b82:	74e2                	ld	s1,56(sp)
    80003b84:	7942                	ld	s2,48(sp)
    80003b86:	79a2                	ld	s3,40(sp)
    80003b88:	6161                	addi	sp,sp,80
    80003b8a:	8082                	ret
  return -1;
    80003b8c:	557d                	li	a0,-1
    80003b8e:	bfc5                	j	80003b7e <filestat+0x60>

0000000080003b90 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b90:	7179                	addi	sp,sp,-48
    80003b92:	f406                	sd	ra,40(sp)
    80003b94:	f022                	sd	s0,32(sp)
    80003b96:	ec26                	sd	s1,24(sp)
    80003b98:	e84a                	sd	s2,16(sp)
    80003b9a:	e44e                	sd	s3,8(sp)
    80003b9c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b9e:	00854783          	lbu	a5,8(a0)
    80003ba2:	c3d5                	beqz	a5,80003c46 <fileread+0xb6>
    80003ba4:	84aa                	mv	s1,a0
    80003ba6:	89ae                	mv	s3,a1
    80003ba8:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003baa:	411c                	lw	a5,0(a0)
    80003bac:	4705                	li	a4,1
    80003bae:	04e78963          	beq	a5,a4,80003c00 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bb2:	470d                	li	a4,3
    80003bb4:	04e78d63          	beq	a5,a4,80003c0e <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bb8:	4709                	li	a4,2
    80003bba:	06e79e63          	bne	a5,a4,80003c36 <fileread+0xa6>
    ilock(f->ip);
    80003bbe:	6d08                	ld	a0,24(a0)
    80003bc0:	fffff097          	auipc	ra,0xfffff
    80003bc4:	008080e7          	jalr	8(ra) # 80002bc8 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bc8:	874a                	mv	a4,s2
    80003bca:	5094                	lw	a3,32(s1)
    80003bcc:	864e                	mv	a2,s3
    80003bce:	4585                	li	a1,1
    80003bd0:	6c88                	ld	a0,24(s1)
    80003bd2:	fffff097          	auipc	ra,0xfffff
    80003bd6:	2aa080e7          	jalr	682(ra) # 80002e7c <readi>
    80003bda:	892a                	mv	s2,a0
    80003bdc:	00a05563          	blez	a0,80003be6 <fileread+0x56>
      f->off += r;
    80003be0:	509c                	lw	a5,32(s1)
    80003be2:	9fa9                	addw	a5,a5,a0
    80003be4:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003be6:	6c88                	ld	a0,24(s1)
    80003be8:	fffff097          	auipc	ra,0xfffff
    80003bec:	0a2080e7          	jalr	162(ra) # 80002c8a <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003bf0:	854a                	mv	a0,s2
    80003bf2:	70a2                	ld	ra,40(sp)
    80003bf4:	7402                	ld	s0,32(sp)
    80003bf6:	64e2                	ld	s1,24(sp)
    80003bf8:	6942                	ld	s2,16(sp)
    80003bfa:	69a2                	ld	s3,8(sp)
    80003bfc:	6145                	addi	sp,sp,48
    80003bfe:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c00:	6908                	ld	a0,16(a0)
    80003c02:	00000097          	auipc	ra,0x0
    80003c06:	3ce080e7          	jalr	974(ra) # 80003fd0 <piperead>
    80003c0a:	892a                	mv	s2,a0
    80003c0c:	b7d5                	j	80003bf0 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c0e:	02451783          	lh	a5,36(a0)
    80003c12:	03079693          	slli	a3,a5,0x30
    80003c16:	92c1                	srli	a3,a3,0x30
    80003c18:	4725                	li	a4,9
    80003c1a:	02d76863          	bltu	a4,a3,80003c4a <fileread+0xba>
    80003c1e:	0792                	slli	a5,a5,0x4
    80003c20:	00015717          	auipc	a4,0x15
    80003c24:	eb870713          	addi	a4,a4,-328 # 80018ad8 <devsw>
    80003c28:	97ba                	add	a5,a5,a4
    80003c2a:	639c                	ld	a5,0(a5)
    80003c2c:	c38d                	beqz	a5,80003c4e <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c2e:	4505                	li	a0,1
    80003c30:	9782                	jalr	a5
    80003c32:	892a                	mv	s2,a0
    80003c34:	bf75                	j	80003bf0 <fileread+0x60>
    panic("fileread");
    80003c36:	00005517          	auipc	a0,0x5
    80003c3a:	b7250513          	addi	a0,a0,-1166 # 800087a8 <syscallnames+0x260>
    80003c3e:	00002097          	auipc	ra,0x2
    80003c42:	084080e7          	jalr	132(ra) # 80005cc2 <panic>
    return -1;
    80003c46:	597d                	li	s2,-1
    80003c48:	b765                	j	80003bf0 <fileread+0x60>
      return -1;
    80003c4a:	597d                	li	s2,-1
    80003c4c:	b755                	j	80003bf0 <fileread+0x60>
    80003c4e:	597d                	li	s2,-1
    80003c50:	b745                	j	80003bf0 <fileread+0x60>

0000000080003c52 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c52:	715d                	addi	sp,sp,-80
    80003c54:	e486                	sd	ra,72(sp)
    80003c56:	e0a2                	sd	s0,64(sp)
    80003c58:	fc26                	sd	s1,56(sp)
    80003c5a:	f84a                	sd	s2,48(sp)
    80003c5c:	f44e                	sd	s3,40(sp)
    80003c5e:	f052                	sd	s4,32(sp)
    80003c60:	ec56                	sd	s5,24(sp)
    80003c62:	e85a                	sd	s6,16(sp)
    80003c64:	e45e                	sd	s7,8(sp)
    80003c66:	e062                	sd	s8,0(sp)
    80003c68:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c6a:	00954783          	lbu	a5,9(a0)
    80003c6e:	10078663          	beqz	a5,80003d7a <filewrite+0x128>
    80003c72:	892a                	mv	s2,a0
    80003c74:	8aae                	mv	s5,a1
    80003c76:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c78:	411c                	lw	a5,0(a0)
    80003c7a:	4705                	li	a4,1
    80003c7c:	02e78263          	beq	a5,a4,80003ca0 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c80:	470d                	li	a4,3
    80003c82:	02e78663          	beq	a5,a4,80003cae <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c86:	4709                	li	a4,2
    80003c88:	0ee79163          	bne	a5,a4,80003d6a <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c8c:	0ac05d63          	blez	a2,80003d46 <filewrite+0xf4>
    int i = 0;
    80003c90:	4981                	li	s3,0
    80003c92:	6b05                	lui	s6,0x1
    80003c94:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003c98:	6b85                	lui	s7,0x1
    80003c9a:	c00b8b9b          	addiw	s7,s7,-1024
    80003c9e:	a861                	j	80003d36 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003ca0:	6908                	ld	a0,16(a0)
    80003ca2:	00000097          	auipc	ra,0x0
    80003ca6:	22e080e7          	jalr	558(ra) # 80003ed0 <pipewrite>
    80003caa:	8a2a                	mv	s4,a0
    80003cac:	a045                	j	80003d4c <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003cae:	02451783          	lh	a5,36(a0)
    80003cb2:	03079693          	slli	a3,a5,0x30
    80003cb6:	92c1                	srli	a3,a3,0x30
    80003cb8:	4725                	li	a4,9
    80003cba:	0cd76263          	bltu	a4,a3,80003d7e <filewrite+0x12c>
    80003cbe:	0792                	slli	a5,a5,0x4
    80003cc0:	00015717          	auipc	a4,0x15
    80003cc4:	e1870713          	addi	a4,a4,-488 # 80018ad8 <devsw>
    80003cc8:	97ba                	add	a5,a5,a4
    80003cca:	679c                	ld	a5,8(a5)
    80003ccc:	cbdd                	beqz	a5,80003d82 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003cce:	4505                	li	a0,1
    80003cd0:	9782                	jalr	a5
    80003cd2:	8a2a                	mv	s4,a0
    80003cd4:	a8a5                	j	80003d4c <filewrite+0xfa>
    80003cd6:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003cda:	00000097          	auipc	ra,0x0
    80003cde:	8b0080e7          	jalr	-1872(ra) # 8000358a <begin_op>
      ilock(f->ip);
    80003ce2:	01893503          	ld	a0,24(s2)
    80003ce6:	fffff097          	auipc	ra,0xfffff
    80003cea:	ee2080e7          	jalr	-286(ra) # 80002bc8 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003cee:	8762                	mv	a4,s8
    80003cf0:	02092683          	lw	a3,32(s2)
    80003cf4:	01598633          	add	a2,s3,s5
    80003cf8:	4585                	li	a1,1
    80003cfa:	01893503          	ld	a0,24(s2)
    80003cfe:	fffff097          	auipc	ra,0xfffff
    80003d02:	276080e7          	jalr	630(ra) # 80002f74 <writei>
    80003d06:	84aa                	mv	s1,a0
    80003d08:	00a05763          	blez	a0,80003d16 <filewrite+0xc4>
        f->off += r;
    80003d0c:	02092783          	lw	a5,32(s2)
    80003d10:	9fa9                	addw	a5,a5,a0
    80003d12:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d16:	01893503          	ld	a0,24(s2)
    80003d1a:	fffff097          	auipc	ra,0xfffff
    80003d1e:	f70080e7          	jalr	-144(ra) # 80002c8a <iunlock>
      end_op();
    80003d22:	00000097          	auipc	ra,0x0
    80003d26:	8e8080e7          	jalr	-1816(ra) # 8000360a <end_op>

      if(r != n1){
    80003d2a:	009c1f63          	bne	s8,s1,80003d48 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d2e:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d32:	0149db63          	bge	s3,s4,80003d48 <filewrite+0xf6>
      int n1 = n - i;
    80003d36:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003d3a:	84be                	mv	s1,a5
    80003d3c:	2781                	sext.w	a5,a5
    80003d3e:	f8fb5ce3          	bge	s6,a5,80003cd6 <filewrite+0x84>
    80003d42:	84de                	mv	s1,s7
    80003d44:	bf49                	j	80003cd6 <filewrite+0x84>
    int i = 0;
    80003d46:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d48:	013a1f63          	bne	s4,s3,80003d66 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d4c:	8552                	mv	a0,s4
    80003d4e:	60a6                	ld	ra,72(sp)
    80003d50:	6406                	ld	s0,64(sp)
    80003d52:	74e2                	ld	s1,56(sp)
    80003d54:	7942                	ld	s2,48(sp)
    80003d56:	79a2                	ld	s3,40(sp)
    80003d58:	7a02                	ld	s4,32(sp)
    80003d5a:	6ae2                	ld	s5,24(sp)
    80003d5c:	6b42                	ld	s6,16(sp)
    80003d5e:	6ba2                	ld	s7,8(sp)
    80003d60:	6c02                	ld	s8,0(sp)
    80003d62:	6161                	addi	sp,sp,80
    80003d64:	8082                	ret
    ret = (i == n ? n : -1);
    80003d66:	5a7d                	li	s4,-1
    80003d68:	b7d5                	j	80003d4c <filewrite+0xfa>
    panic("filewrite");
    80003d6a:	00005517          	auipc	a0,0x5
    80003d6e:	a4e50513          	addi	a0,a0,-1458 # 800087b8 <syscallnames+0x270>
    80003d72:	00002097          	auipc	ra,0x2
    80003d76:	f50080e7          	jalr	-176(ra) # 80005cc2 <panic>
    return -1;
    80003d7a:	5a7d                	li	s4,-1
    80003d7c:	bfc1                	j	80003d4c <filewrite+0xfa>
      return -1;
    80003d7e:	5a7d                	li	s4,-1
    80003d80:	b7f1                	j	80003d4c <filewrite+0xfa>
    80003d82:	5a7d                	li	s4,-1
    80003d84:	b7e1                	j	80003d4c <filewrite+0xfa>

0000000080003d86 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d86:	7179                	addi	sp,sp,-48
    80003d88:	f406                	sd	ra,40(sp)
    80003d8a:	f022                	sd	s0,32(sp)
    80003d8c:	ec26                	sd	s1,24(sp)
    80003d8e:	e84a                	sd	s2,16(sp)
    80003d90:	e44e                	sd	s3,8(sp)
    80003d92:	e052                	sd	s4,0(sp)
    80003d94:	1800                	addi	s0,sp,48
    80003d96:	84aa                	mv	s1,a0
    80003d98:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d9a:	0005b023          	sd	zero,0(a1)
    80003d9e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003da2:	00000097          	auipc	ra,0x0
    80003da6:	bf8080e7          	jalr	-1032(ra) # 8000399a <filealloc>
    80003daa:	e088                	sd	a0,0(s1)
    80003dac:	c551                	beqz	a0,80003e38 <pipealloc+0xb2>
    80003dae:	00000097          	auipc	ra,0x0
    80003db2:	bec080e7          	jalr	-1044(ra) # 8000399a <filealloc>
    80003db6:	00aa3023          	sd	a0,0(s4)
    80003dba:	c92d                	beqz	a0,80003e2c <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003dbc:	ffffc097          	auipc	ra,0xffffc
    80003dc0:	35c080e7          	jalr	860(ra) # 80000118 <kalloc>
    80003dc4:	892a                	mv	s2,a0
    80003dc6:	c125                	beqz	a0,80003e26 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003dc8:	4985                	li	s3,1
    80003dca:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003dce:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003dd2:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003dd6:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003dda:	00004597          	auipc	a1,0x4
    80003dde:	60e58593          	addi	a1,a1,1550 # 800083e8 <states.1736+0x1a0>
    80003de2:	00002097          	auipc	ra,0x2
    80003de6:	39a080e7          	jalr	922(ra) # 8000617c <initlock>
  (*f0)->type = FD_PIPE;
    80003dea:	609c                	ld	a5,0(s1)
    80003dec:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003df0:	609c                	ld	a5,0(s1)
    80003df2:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003df6:	609c                	ld	a5,0(s1)
    80003df8:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003dfc:	609c                	ld	a5,0(s1)
    80003dfe:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e02:	000a3783          	ld	a5,0(s4)
    80003e06:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e0a:	000a3783          	ld	a5,0(s4)
    80003e0e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e12:	000a3783          	ld	a5,0(s4)
    80003e16:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e1a:	000a3783          	ld	a5,0(s4)
    80003e1e:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e22:	4501                	li	a0,0
    80003e24:	a025                	j	80003e4c <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e26:	6088                	ld	a0,0(s1)
    80003e28:	e501                	bnez	a0,80003e30 <pipealloc+0xaa>
    80003e2a:	a039                	j	80003e38 <pipealloc+0xb2>
    80003e2c:	6088                	ld	a0,0(s1)
    80003e2e:	c51d                	beqz	a0,80003e5c <pipealloc+0xd6>
    fileclose(*f0);
    80003e30:	00000097          	auipc	ra,0x0
    80003e34:	c26080e7          	jalr	-986(ra) # 80003a56 <fileclose>
  if(*f1)
    80003e38:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e3c:	557d                	li	a0,-1
  if(*f1)
    80003e3e:	c799                	beqz	a5,80003e4c <pipealloc+0xc6>
    fileclose(*f1);
    80003e40:	853e                	mv	a0,a5
    80003e42:	00000097          	auipc	ra,0x0
    80003e46:	c14080e7          	jalr	-1004(ra) # 80003a56 <fileclose>
  return -1;
    80003e4a:	557d                	li	a0,-1
}
    80003e4c:	70a2                	ld	ra,40(sp)
    80003e4e:	7402                	ld	s0,32(sp)
    80003e50:	64e2                	ld	s1,24(sp)
    80003e52:	6942                	ld	s2,16(sp)
    80003e54:	69a2                	ld	s3,8(sp)
    80003e56:	6a02                	ld	s4,0(sp)
    80003e58:	6145                	addi	sp,sp,48
    80003e5a:	8082                	ret
  return -1;
    80003e5c:	557d                	li	a0,-1
    80003e5e:	b7fd                	j	80003e4c <pipealloc+0xc6>

0000000080003e60 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e60:	1101                	addi	sp,sp,-32
    80003e62:	ec06                	sd	ra,24(sp)
    80003e64:	e822                	sd	s0,16(sp)
    80003e66:	e426                	sd	s1,8(sp)
    80003e68:	e04a                	sd	s2,0(sp)
    80003e6a:	1000                	addi	s0,sp,32
    80003e6c:	84aa                	mv	s1,a0
    80003e6e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e70:	00002097          	auipc	ra,0x2
    80003e74:	39c080e7          	jalr	924(ra) # 8000620c <acquire>
  if(writable){
    80003e78:	02090d63          	beqz	s2,80003eb2 <pipeclose+0x52>
    pi->writeopen = 0;
    80003e7c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e80:	21848513          	addi	a0,s1,536
    80003e84:	ffffd097          	auipc	ra,0xffffd
    80003e88:	758080e7          	jalr	1880(ra) # 800015dc <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e8c:	2204b783          	ld	a5,544(s1)
    80003e90:	eb95                	bnez	a5,80003ec4 <pipeclose+0x64>
    release(&pi->lock);
    80003e92:	8526                	mv	a0,s1
    80003e94:	00002097          	auipc	ra,0x2
    80003e98:	42c080e7          	jalr	1068(ra) # 800062c0 <release>
    kfree((char*)pi);
    80003e9c:	8526                	mv	a0,s1
    80003e9e:	ffffc097          	auipc	ra,0xffffc
    80003ea2:	17e080e7          	jalr	382(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003ea6:	60e2                	ld	ra,24(sp)
    80003ea8:	6442                	ld	s0,16(sp)
    80003eaa:	64a2                	ld	s1,8(sp)
    80003eac:	6902                	ld	s2,0(sp)
    80003eae:	6105                	addi	sp,sp,32
    80003eb0:	8082                	ret
    pi->readopen = 0;
    80003eb2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003eb6:	21c48513          	addi	a0,s1,540
    80003eba:	ffffd097          	auipc	ra,0xffffd
    80003ebe:	722080e7          	jalr	1826(ra) # 800015dc <wakeup>
    80003ec2:	b7e9                	j	80003e8c <pipeclose+0x2c>
    release(&pi->lock);
    80003ec4:	8526                	mv	a0,s1
    80003ec6:	00002097          	auipc	ra,0x2
    80003eca:	3fa080e7          	jalr	1018(ra) # 800062c0 <release>
}
    80003ece:	bfe1                	j	80003ea6 <pipeclose+0x46>

0000000080003ed0 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003ed0:	7159                	addi	sp,sp,-112
    80003ed2:	f486                	sd	ra,104(sp)
    80003ed4:	f0a2                	sd	s0,96(sp)
    80003ed6:	eca6                	sd	s1,88(sp)
    80003ed8:	e8ca                	sd	s2,80(sp)
    80003eda:	e4ce                	sd	s3,72(sp)
    80003edc:	e0d2                	sd	s4,64(sp)
    80003ede:	fc56                	sd	s5,56(sp)
    80003ee0:	f85a                	sd	s6,48(sp)
    80003ee2:	f45e                	sd	s7,40(sp)
    80003ee4:	f062                	sd	s8,32(sp)
    80003ee6:	ec66                	sd	s9,24(sp)
    80003ee8:	1880                	addi	s0,sp,112
    80003eea:	84aa                	mv	s1,a0
    80003eec:	8aae                	mv	s5,a1
    80003eee:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ef0:	ffffd097          	auipc	ra,0xffffd
    80003ef4:	f68080e7          	jalr	-152(ra) # 80000e58 <myproc>
    80003ef8:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003efa:	8526                	mv	a0,s1
    80003efc:	00002097          	auipc	ra,0x2
    80003f00:	310080e7          	jalr	784(ra) # 8000620c <acquire>
  while(i < n){
    80003f04:	0d405463          	blez	s4,80003fcc <pipewrite+0xfc>
    80003f08:	8ba6                	mv	s7,s1
  int i = 0;
    80003f0a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f0c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f0e:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f12:	21c48c13          	addi	s8,s1,540
    80003f16:	a08d                	j	80003f78 <pipewrite+0xa8>
      release(&pi->lock);
    80003f18:	8526                	mv	a0,s1
    80003f1a:	00002097          	auipc	ra,0x2
    80003f1e:	3a6080e7          	jalr	934(ra) # 800062c0 <release>
      return -1;
    80003f22:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f24:	854a                	mv	a0,s2
    80003f26:	70a6                	ld	ra,104(sp)
    80003f28:	7406                	ld	s0,96(sp)
    80003f2a:	64e6                	ld	s1,88(sp)
    80003f2c:	6946                	ld	s2,80(sp)
    80003f2e:	69a6                	ld	s3,72(sp)
    80003f30:	6a06                	ld	s4,64(sp)
    80003f32:	7ae2                	ld	s5,56(sp)
    80003f34:	7b42                	ld	s6,48(sp)
    80003f36:	7ba2                	ld	s7,40(sp)
    80003f38:	7c02                	ld	s8,32(sp)
    80003f3a:	6ce2                	ld	s9,24(sp)
    80003f3c:	6165                	addi	sp,sp,112
    80003f3e:	8082                	ret
      wakeup(&pi->nread);
    80003f40:	8566                	mv	a0,s9
    80003f42:	ffffd097          	auipc	ra,0xffffd
    80003f46:	69a080e7          	jalr	1690(ra) # 800015dc <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f4a:	85de                	mv	a1,s7
    80003f4c:	8562                	mv	a0,s8
    80003f4e:	ffffd097          	auipc	ra,0xffffd
    80003f52:	62a080e7          	jalr	1578(ra) # 80001578 <sleep>
    80003f56:	a839                	j	80003f74 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f58:	21c4a783          	lw	a5,540(s1)
    80003f5c:	0017871b          	addiw	a4,a5,1
    80003f60:	20e4ae23          	sw	a4,540(s1)
    80003f64:	1ff7f793          	andi	a5,a5,511
    80003f68:	97a6                	add	a5,a5,s1
    80003f6a:	f9f44703          	lbu	a4,-97(s0)
    80003f6e:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f72:	2905                	addiw	s2,s2,1
  while(i < n){
    80003f74:	05495063          	bge	s2,s4,80003fb4 <pipewrite+0xe4>
    if(pi->readopen == 0 || killed(pr)){
    80003f78:	2204a783          	lw	a5,544(s1)
    80003f7c:	dfd1                	beqz	a5,80003f18 <pipewrite+0x48>
    80003f7e:	854e                	mv	a0,s3
    80003f80:	ffffe097          	auipc	ra,0xffffe
    80003f84:	8a0080e7          	jalr	-1888(ra) # 80001820 <killed>
    80003f88:	f941                	bnez	a0,80003f18 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f8a:	2184a783          	lw	a5,536(s1)
    80003f8e:	21c4a703          	lw	a4,540(s1)
    80003f92:	2007879b          	addiw	a5,a5,512
    80003f96:	faf705e3          	beq	a4,a5,80003f40 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f9a:	4685                	li	a3,1
    80003f9c:	01590633          	add	a2,s2,s5
    80003fa0:	f9f40593          	addi	a1,s0,-97
    80003fa4:	0509b503          	ld	a0,80(s3)
    80003fa8:	ffffd097          	auipc	ra,0xffffd
    80003fac:	bfa080e7          	jalr	-1030(ra) # 80000ba2 <copyin>
    80003fb0:	fb6514e3          	bne	a0,s6,80003f58 <pipewrite+0x88>
  wakeup(&pi->nread);
    80003fb4:	21848513          	addi	a0,s1,536
    80003fb8:	ffffd097          	auipc	ra,0xffffd
    80003fbc:	624080e7          	jalr	1572(ra) # 800015dc <wakeup>
  release(&pi->lock);
    80003fc0:	8526                	mv	a0,s1
    80003fc2:	00002097          	auipc	ra,0x2
    80003fc6:	2fe080e7          	jalr	766(ra) # 800062c0 <release>
  return i;
    80003fca:	bfa9                	j	80003f24 <pipewrite+0x54>
  int i = 0;
    80003fcc:	4901                	li	s2,0
    80003fce:	b7dd                	j	80003fb4 <pipewrite+0xe4>

0000000080003fd0 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fd0:	715d                	addi	sp,sp,-80
    80003fd2:	e486                	sd	ra,72(sp)
    80003fd4:	e0a2                	sd	s0,64(sp)
    80003fd6:	fc26                	sd	s1,56(sp)
    80003fd8:	f84a                	sd	s2,48(sp)
    80003fda:	f44e                	sd	s3,40(sp)
    80003fdc:	f052                	sd	s4,32(sp)
    80003fde:	ec56                	sd	s5,24(sp)
    80003fe0:	e85a                	sd	s6,16(sp)
    80003fe2:	0880                	addi	s0,sp,80
    80003fe4:	84aa                	mv	s1,a0
    80003fe6:	892e                	mv	s2,a1
    80003fe8:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003fea:	ffffd097          	auipc	ra,0xffffd
    80003fee:	e6e080e7          	jalr	-402(ra) # 80000e58 <myproc>
    80003ff2:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003ff4:	8b26                	mv	s6,s1
    80003ff6:	8526                	mv	a0,s1
    80003ff8:	00002097          	auipc	ra,0x2
    80003ffc:	214080e7          	jalr	532(ra) # 8000620c <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004000:	2184a703          	lw	a4,536(s1)
    80004004:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004008:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000400c:	02f71763          	bne	a4,a5,8000403a <piperead+0x6a>
    80004010:	2244a783          	lw	a5,548(s1)
    80004014:	c39d                	beqz	a5,8000403a <piperead+0x6a>
    if(killed(pr)){
    80004016:	8552                	mv	a0,s4
    80004018:	ffffe097          	auipc	ra,0xffffe
    8000401c:	808080e7          	jalr	-2040(ra) # 80001820 <killed>
    80004020:	e941                	bnez	a0,800040b0 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004022:	85da                	mv	a1,s6
    80004024:	854e                	mv	a0,s3
    80004026:	ffffd097          	auipc	ra,0xffffd
    8000402a:	552080e7          	jalr	1362(ra) # 80001578 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000402e:	2184a703          	lw	a4,536(s1)
    80004032:	21c4a783          	lw	a5,540(s1)
    80004036:	fcf70de3          	beq	a4,a5,80004010 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000403a:	09505263          	blez	s5,800040be <piperead+0xee>
    8000403e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004040:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004042:	2184a783          	lw	a5,536(s1)
    80004046:	21c4a703          	lw	a4,540(s1)
    8000404a:	02f70d63          	beq	a4,a5,80004084 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000404e:	0017871b          	addiw	a4,a5,1
    80004052:	20e4ac23          	sw	a4,536(s1)
    80004056:	1ff7f793          	andi	a5,a5,511
    8000405a:	97a6                	add	a5,a5,s1
    8000405c:	0187c783          	lbu	a5,24(a5)
    80004060:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004064:	4685                	li	a3,1
    80004066:	fbf40613          	addi	a2,s0,-65
    8000406a:	85ca                	mv	a1,s2
    8000406c:	050a3503          	ld	a0,80(s4)
    80004070:	ffffd097          	auipc	ra,0xffffd
    80004074:	aa6080e7          	jalr	-1370(ra) # 80000b16 <copyout>
    80004078:	01650663          	beq	a0,s6,80004084 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000407c:	2985                	addiw	s3,s3,1
    8000407e:	0905                	addi	s2,s2,1
    80004080:	fd3a91e3          	bne	s5,s3,80004042 <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004084:	21c48513          	addi	a0,s1,540
    80004088:	ffffd097          	auipc	ra,0xffffd
    8000408c:	554080e7          	jalr	1364(ra) # 800015dc <wakeup>
  release(&pi->lock);
    80004090:	8526                	mv	a0,s1
    80004092:	00002097          	auipc	ra,0x2
    80004096:	22e080e7          	jalr	558(ra) # 800062c0 <release>
  return i;
}
    8000409a:	854e                	mv	a0,s3
    8000409c:	60a6                	ld	ra,72(sp)
    8000409e:	6406                	ld	s0,64(sp)
    800040a0:	74e2                	ld	s1,56(sp)
    800040a2:	7942                	ld	s2,48(sp)
    800040a4:	79a2                	ld	s3,40(sp)
    800040a6:	7a02                	ld	s4,32(sp)
    800040a8:	6ae2                	ld	s5,24(sp)
    800040aa:	6b42                	ld	s6,16(sp)
    800040ac:	6161                	addi	sp,sp,80
    800040ae:	8082                	ret
      release(&pi->lock);
    800040b0:	8526                	mv	a0,s1
    800040b2:	00002097          	auipc	ra,0x2
    800040b6:	20e080e7          	jalr	526(ra) # 800062c0 <release>
      return -1;
    800040ba:	59fd                	li	s3,-1
    800040bc:	bff9                	j	8000409a <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040be:	4981                	li	s3,0
    800040c0:	b7d1                	j	80004084 <piperead+0xb4>

00000000800040c2 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800040c2:	1141                	addi	sp,sp,-16
    800040c4:	e422                	sd	s0,8(sp)
    800040c6:	0800                	addi	s0,sp,16
    800040c8:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800040ca:	8905                	andi	a0,a0,1
    800040cc:	c111                	beqz	a0,800040d0 <flags2perm+0xe>
      perm = PTE_X;
    800040ce:	4521                	li	a0,8
    if(flags & 0x2)
    800040d0:	8b89                	andi	a5,a5,2
    800040d2:	c399                	beqz	a5,800040d8 <flags2perm+0x16>
      perm |= PTE_W;
    800040d4:	00456513          	ori	a0,a0,4
    return perm;
}
    800040d8:	6422                	ld	s0,8(sp)
    800040da:	0141                	addi	sp,sp,16
    800040dc:	8082                	ret

00000000800040de <exec>:

int
exec(char *path, char **argv)
{
    800040de:	df010113          	addi	sp,sp,-528
    800040e2:	20113423          	sd	ra,520(sp)
    800040e6:	20813023          	sd	s0,512(sp)
    800040ea:	ffa6                	sd	s1,504(sp)
    800040ec:	fbca                	sd	s2,496(sp)
    800040ee:	f7ce                	sd	s3,488(sp)
    800040f0:	f3d2                	sd	s4,480(sp)
    800040f2:	efd6                	sd	s5,472(sp)
    800040f4:	ebda                	sd	s6,464(sp)
    800040f6:	e7de                	sd	s7,456(sp)
    800040f8:	e3e2                	sd	s8,448(sp)
    800040fa:	ff66                	sd	s9,440(sp)
    800040fc:	fb6a                	sd	s10,432(sp)
    800040fe:	f76e                	sd	s11,424(sp)
    80004100:	0c00                	addi	s0,sp,528
    80004102:	84aa                	mv	s1,a0
    80004104:	dea43c23          	sd	a0,-520(s0)
    80004108:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000410c:	ffffd097          	auipc	ra,0xffffd
    80004110:	d4c080e7          	jalr	-692(ra) # 80000e58 <myproc>
    80004114:	892a                	mv	s2,a0

  begin_op();
    80004116:	fffff097          	auipc	ra,0xfffff
    8000411a:	474080e7          	jalr	1140(ra) # 8000358a <begin_op>

  if((ip = namei(path)) == 0){
    8000411e:	8526                	mv	a0,s1
    80004120:	fffff097          	auipc	ra,0xfffff
    80004124:	24e080e7          	jalr	590(ra) # 8000336e <namei>
    80004128:	c92d                	beqz	a0,8000419a <exec+0xbc>
    8000412a:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000412c:	fffff097          	auipc	ra,0xfffff
    80004130:	a9c080e7          	jalr	-1380(ra) # 80002bc8 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004134:	04000713          	li	a4,64
    80004138:	4681                	li	a3,0
    8000413a:	e5040613          	addi	a2,s0,-432
    8000413e:	4581                	li	a1,0
    80004140:	8526                	mv	a0,s1
    80004142:	fffff097          	auipc	ra,0xfffff
    80004146:	d3a080e7          	jalr	-710(ra) # 80002e7c <readi>
    8000414a:	04000793          	li	a5,64
    8000414e:	00f51a63          	bne	a0,a5,80004162 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004152:	e5042703          	lw	a4,-432(s0)
    80004156:	464c47b7          	lui	a5,0x464c4
    8000415a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000415e:	04f70463          	beq	a4,a5,800041a6 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004162:	8526                	mv	a0,s1
    80004164:	fffff097          	auipc	ra,0xfffff
    80004168:	cc6080e7          	jalr	-826(ra) # 80002e2a <iunlockput>
    end_op();
    8000416c:	fffff097          	auipc	ra,0xfffff
    80004170:	49e080e7          	jalr	1182(ra) # 8000360a <end_op>
  }
  return -1;
    80004174:	557d                	li	a0,-1
}
    80004176:	20813083          	ld	ra,520(sp)
    8000417a:	20013403          	ld	s0,512(sp)
    8000417e:	74fe                	ld	s1,504(sp)
    80004180:	795e                	ld	s2,496(sp)
    80004182:	79be                	ld	s3,488(sp)
    80004184:	7a1e                	ld	s4,480(sp)
    80004186:	6afe                	ld	s5,472(sp)
    80004188:	6b5e                	ld	s6,464(sp)
    8000418a:	6bbe                	ld	s7,456(sp)
    8000418c:	6c1e                	ld	s8,448(sp)
    8000418e:	7cfa                	ld	s9,440(sp)
    80004190:	7d5a                	ld	s10,432(sp)
    80004192:	7dba                	ld	s11,424(sp)
    80004194:	21010113          	addi	sp,sp,528
    80004198:	8082                	ret
    end_op();
    8000419a:	fffff097          	auipc	ra,0xfffff
    8000419e:	470080e7          	jalr	1136(ra) # 8000360a <end_op>
    return -1;
    800041a2:	557d                	li	a0,-1
    800041a4:	bfc9                	j	80004176 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800041a6:	854a                	mv	a0,s2
    800041a8:	ffffd097          	auipc	ra,0xffffd
    800041ac:	d74080e7          	jalr	-652(ra) # 80000f1c <proc_pagetable>
    800041b0:	8baa                	mv	s7,a0
    800041b2:	d945                	beqz	a0,80004162 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041b4:	e7042983          	lw	s3,-400(s0)
    800041b8:	e8845783          	lhu	a5,-376(s0)
    800041bc:	c7ad                	beqz	a5,80004226 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041be:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041c0:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    800041c2:	6c85                	lui	s9,0x1
    800041c4:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800041c8:	def43823          	sd	a5,-528(s0)
    800041cc:	ac0d                	j	800043fe <exec+0x320>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800041ce:	00004517          	auipc	a0,0x4
    800041d2:	5fa50513          	addi	a0,a0,1530 # 800087c8 <syscallnames+0x280>
    800041d6:	00002097          	auipc	ra,0x2
    800041da:	aec080e7          	jalr	-1300(ra) # 80005cc2 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041de:	8756                	mv	a4,s5
    800041e0:	012d86bb          	addw	a3,s11,s2
    800041e4:	4581                	li	a1,0
    800041e6:	8526                	mv	a0,s1
    800041e8:	fffff097          	auipc	ra,0xfffff
    800041ec:	c94080e7          	jalr	-876(ra) # 80002e7c <readi>
    800041f0:	2501                	sext.w	a0,a0
    800041f2:	1aaa9a63          	bne	s5,a0,800043a6 <exec+0x2c8>
  for(i = 0; i < sz; i += PGSIZE){
    800041f6:	6785                	lui	a5,0x1
    800041f8:	0127893b          	addw	s2,a5,s2
    800041fc:	77fd                	lui	a5,0xfffff
    800041fe:	01478a3b          	addw	s4,a5,s4
    80004202:	1f897563          	bgeu	s2,s8,800043ec <exec+0x30e>
    pa = walkaddr(pagetable, va + i);
    80004206:	02091593          	slli	a1,s2,0x20
    8000420a:	9181                	srli	a1,a1,0x20
    8000420c:	95ea                	add	a1,a1,s10
    8000420e:	855e                	mv	a0,s7
    80004210:	ffffc097          	auipc	ra,0xffffc
    80004214:	2fa080e7          	jalr	762(ra) # 8000050a <walkaddr>
    80004218:	862a                	mv	a2,a0
    if(pa == 0)
    8000421a:	d955                	beqz	a0,800041ce <exec+0xf0>
      n = PGSIZE;
    8000421c:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    8000421e:	fd9a70e3          	bgeu	s4,s9,800041de <exec+0x100>
      n = sz - i;
    80004222:	8ad2                	mv	s5,s4
    80004224:	bf6d                	j	800041de <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004226:	4a01                	li	s4,0
  iunlockput(ip);
    80004228:	8526                	mv	a0,s1
    8000422a:	fffff097          	auipc	ra,0xfffff
    8000422e:	c00080e7          	jalr	-1024(ra) # 80002e2a <iunlockput>
  end_op();
    80004232:	fffff097          	auipc	ra,0xfffff
    80004236:	3d8080e7          	jalr	984(ra) # 8000360a <end_op>
  p = myproc();
    8000423a:	ffffd097          	auipc	ra,0xffffd
    8000423e:	c1e080e7          	jalr	-994(ra) # 80000e58 <myproc>
    80004242:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004244:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004248:	6785                	lui	a5,0x1
    8000424a:	17fd                	addi	a5,a5,-1
    8000424c:	9a3e                	add	s4,s4,a5
    8000424e:	757d                	lui	a0,0xfffff
    80004250:	00aa77b3          	and	a5,s4,a0
    80004254:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004258:	4691                	li	a3,4
    8000425a:	6609                	lui	a2,0x2
    8000425c:	963e                	add	a2,a2,a5
    8000425e:	85be                	mv	a1,a5
    80004260:	855e                	mv	a0,s7
    80004262:	ffffc097          	auipc	ra,0xffffc
    80004266:	65c080e7          	jalr	1628(ra) # 800008be <uvmalloc>
    8000426a:	8b2a                	mv	s6,a0
  ip = 0;
    8000426c:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000426e:	12050c63          	beqz	a0,800043a6 <exec+0x2c8>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004272:	75f9                	lui	a1,0xffffe
    80004274:	95aa                	add	a1,a1,a0
    80004276:	855e                	mv	a0,s7
    80004278:	ffffd097          	auipc	ra,0xffffd
    8000427c:	86c080e7          	jalr	-1940(ra) # 80000ae4 <uvmclear>
  stackbase = sp - PGSIZE;
    80004280:	7c7d                	lui	s8,0xfffff
    80004282:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004284:	e0043783          	ld	a5,-512(s0)
    80004288:	6388                	ld	a0,0(a5)
    8000428a:	c535                	beqz	a0,800042f6 <exec+0x218>
    8000428c:	e9040993          	addi	s3,s0,-368
    80004290:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004294:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004296:	ffffc097          	auipc	ra,0xffffc
    8000429a:	066080e7          	jalr	102(ra) # 800002fc <strlen>
    8000429e:	2505                	addiw	a0,a0,1
    800042a0:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800042a4:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800042a8:	13896663          	bltu	s2,s8,800043d4 <exec+0x2f6>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800042ac:	e0043d83          	ld	s11,-512(s0)
    800042b0:	000dba03          	ld	s4,0(s11)
    800042b4:	8552                	mv	a0,s4
    800042b6:	ffffc097          	auipc	ra,0xffffc
    800042ba:	046080e7          	jalr	70(ra) # 800002fc <strlen>
    800042be:	0015069b          	addiw	a3,a0,1
    800042c2:	8652                	mv	a2,s4
    800042c4:	85ca                	mv	a1,s2
    800042c6:	855e                	mv	a0,s7
    800042c8:	ffffd097          	auipc	ra,0xffffd
    800042cc:	84e080e7          	jalr	-1970(ra) # 80000b16 <copyout>
    800042d0:	10054663          	bltz	a0,800043dc <exec+0x2fe>
    ustack[argc] = sp;
    800042d4:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800042d8:	0485                	addi	s1,s1,1
    800042da:	008d8793          	addi	a5,s11,8
    800042de:	e0f43023          	sd	a5,-512(s0)
    800042e2:	008db503          	ld	a0,8(s11)
    800042e6:	c911                	beqz	a0,800042fa <exec+0x21c>
    if(argc >= MAXARG)
    800042e8:	09a1                	addi	s3,s3,8
    800042ea:	fb3c96e3          	bne	s9,s3,80004296 <exec+0x1b8>
  sz = sz1;
    800042ee:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042f2:	4481                	li	s1,0
    800042f4:	a84d                	j	800043a6 <exec+0x2c8>
  sp = sz;
    800042f6:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800042f8:	4481                	li	s1,0
  ustack[argc] = 0;
    800042fa:	00349793          	slli	a5,s1,0x3
    800042fe:	f9040713          	addi	a4,s0,-112
    80004302:	97ba                	add	a5,a5,a4
    80004304:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004308:	00148693          	addi	a3,s1,1
    8000430c:	068e                	slli	a3,a3,0x3
    8000430e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004312:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004316:	01897663          	bgeu	s2,s8,80004322 <exec+0x244>
  sz = sz1;
    8000431a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000431e:	4481                	li	s1,0
    80004320:	a059                	j	800043a6 <exec+0x2c8>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004322:	e9040613          	addi	a2,s0,-368
    80004326:	85ca                	mv	a1,s2
    80004328:	855e                	mv	a0,s7
    8000432a:	ffffc097          	auipc	ra,0xffffc
    8000432e:	7ec080e7          	jalr	2028(ra) # 80000b16 <copyout>
    80004332:	0a054963          	bltz	a0,800043e4 <exec+0x306>
  p->trapframe->a1 = sp;
    80004336:	058ab783          	ld	a5,88(s5)
    8000433a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000433e:	df843783          	ld	a5,-520(s0)
    80004342:	0007c703          	lbu	a4,0(a5)
    80004346:	cf11                	beqz	a4,80004362 <exec+0x284>
    80004348:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000434a:	02f00693          	li	a3,47
    8000434e:	a039                	j	8000435c <exec+0x27e>
      last = s+1;
    80004350:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004354:	0785                	addi	a5,a5,1
    80004356:	fff7c703          	lbu	a4,-1(a5)
    8000435a:	c701                	beqz	a4,80004362 <exec+0x284>
    if(*s == '/')
    8000435c:	fed71ce3          	bne	a4,a3,80004354 <exec+0x276>
    80004360:	bfc5                	j	80004350 <exec+0x272>
  safestrcpy(p->name, last, sizeof(p->name));
    80004362:	4641                	li	a2,16
    80004364:	df843583          	ld	a1,-520(s0)
    80004368:	158a8513          	addi	a0,s5,344
    8000436c:	ffffc097          	auipc	ra,0xffffc
    80004370:	f5e080e7          	jalr	-162(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    80004374:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004378:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    8000437c:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004380:	058ab783          	ld	a5,88(s5)
    80004384:	e6843703          	ld	a4,-408(s0)
    80004388:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000438a:	058ab783          	ld	a5,88(s5)
    8000438e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004392:	85ea                	mv	a1,s10
    80004394:	ffffd097          	auipc	ra,0xffffd
    80004398:	c24080e7          	jalr	-988(ra) # 80000fb8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000439c:	0004851b          	sext.w	a0,s1
    800043a0:	bbd9                	j	80004176 <exec+0x98>
    800043a2:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    800043a6:	e0843583          	ld	a1,-504(s0)
    800043aa:	855e                	mv	a0,s7
    800043ac:	ffffd097          	auipc	ra,0xffffd
    800043b0:	c0c080e7          	jalr	-1012(ra) # 80000fb8 <proc_freepagetable>
  if(ip){
    800043b4:	da0497e3          	bnez	s1,80004162 <exec+0x84>
  return -1;
    800043b8:	557d                	li	a0,-1
    800043ba:	bb75                	j	80004176 <exec+0x98>
    800043bc:	e1443423          	sd	s4,-504(s0)
    800043c0:	b7dd                	j	800043a6 <exec+0x2c8>
    800043c2:	e1443423          	sd	s4,-504(s0)
    800043c6:	b7c5                	j	800043a6 <exec+0x2c8>
    800043c8:	e1443423          	sd	s4,-504(s0)
    800043cc:	bfe9                	j	800043a6 <exec+0x2c8>
    800043ce:	e1443423          	sd	s4,-504(s0)
    800043d2:	bfd1                	j	800043a6 <exec+0x2c8>
  sz = sz1;
    800043d4:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043d8:	4481                	li	s1,0
    800043da:	b7f1                	j	800043a6 <exec+0x2c8>
  sz = sz1;
    800043dc:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043e0:	4481                	li	s1,0
    800043e2:	b7d1                	j	800043a6 <exec+0x2c8>
  sz = sz1;
    800043e4:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043e8:	4481                	li	s1,0
    800043ea:	bf75                	j	800043a6 <exec+0x2c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800043ec:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043f0:	2b05                	addiw	s6,s6,1
    800043f2:	0389899b          	addiw	s3,s3,56
    800043f6:	e8845783          	lhu	a5,-376(s0)
    800043fa:	e2fb57e3          	bge	s6,a5,80004228 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043fe:	2981                	sext.w	s3,s3
    80004400:	03800713          	li	a4,56
    80004404:	86ce                	mv	a3,s3
    80004406:	e1840613          	addi	a2,s0,-488
    8000440a:	4581                	li	a1,0
    8000440c:	8526                	mv	a0,s1
    8000440e:	fffff097          	auipc	ra,0xfffff
    80004412:	a6e080e7          	jalr	-1426(ra) # 80002e7c <readi>
    80004416:	03800793          	li	a5,56
    8000441a:	f8f514e3          	bne	a0,a5,800043a2 <exec+0x2c4>
    if(ph.type != ELF_PROG_LOAD)
    8000441e:	e1842783          	lw	a5,-488(s0)
    80004422:	4705                	li	a4,1
    80004424:	fce796e3          	bne	a5,a4,800043f0 <exec+0x312>
    if(ph.memsz < ph.filesz)
    80004428:	e4043903          	ld	s2,-448(s0)
    8000442c:	e3843783          	ld	a5,-456(s0)
    80004430:	f8f966e3          	bltu	s2,a5,800043bc <exec+0x2de>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004434:	e2843783          	ld	a5,-472(s0)
    80004438:	993e                	add	s2,s2,a5
    8000443a:	f8f964e3          	bltu	s2,a5,800043c2 <exec+0x2e4>
    if(ph.vaddr % PGSIZE != 0)
    8000443e:	df043703          	ld	a4,-528(s0)
    80004442:	8ff9                	and	a5,a5,a4
    80004444:	f3d1                	bnez	a5,800043c8 <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004446:	e1c42503          	lw	a0,-484(s0)
    8000444a:	00000097          	auipc	ra,0x0
    8000444e:	c78080e7          	jalr	-904(ra) # 800040c2 <flags2perm>
    80004452:	86aa                	mv	a3,a0
    80004454:	864a                	mv	a2,s2
    80004456:	85d2                	mv	a1,s4
    80004458:	855e                	mv	a0,s7
    8000445a:	ffffc097          	auipc	ra,0xffffc
    8000445e:	464080e7          	jalr	1124(ra) # 800008be <uvmalloc>
    80004462:	e0a43423          	sd	a0,-504(s0)
    80004466:	d525                	beqz	a0,800043ce <exec+0x2f0>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004468:	e2843d03          	ld	s10,-472(s0)
    8000446c:	e2042d83          	lw	s11,-480(s0)
    80004470:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004474:	f60c0ce3          	beqz	s8,800043ec <exec+0x30e>
    80004478:	8a62                	mv	s4,s8
    8000447a:	4901                	li	s2,0
    8000447c:	b369                	j	80004206 <exec+0x128>

000000008000447e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000447e:	7179                	addi	sp,sp,-48
    80004480:	f406                	sd	ra,40(sp)
    80004482:	f022                	sd	s0,32(sp)
    80004484:	ec26                	sd	s1,24(sp)
    80004486:	e84a                	sd	s2,16(sp)
    80004488:	1800                	addi	s0,sp,48
    8000448a:	892e                	mv	s2,a1
    8000448c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000448e:	fdc40593          	addi	a1,s0,-36
    80004492:	ffffe097          	auipc	ra,0xffffe
    80004496:	b52080e7          	jalr	-1198(ra) # 80001fe4 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000449a:	fdc42703          	lw	a4,-36(s0)
    8000449e:	47bd                	li	a5,15
    800044a0:	02e7eb63          	bltu	a5,a4,800044d6 <argfd+0x58>
    800044a4:	ffffd097          	auipc	ra,0xffffd
    800044a8:	9b4080e7          	jalr	-1612(ra) # 80000e58 <myproc>
    800044ac:	fdc42703          	lw	a4,-36(s0)
    800044b0:	01a70793          	addi	a5,a4,26
    800044b4:	078e                	slli	a5,a5,0x3
    800044b6:	953e                	add	a0,a0,a5
    800044b8:	611c                	ld	a5,0(a0)
    800044ba:	c385                	beqz	a5,800044da <argfd+0x5c>
    return -1;
  if(pfd)
    800044bc:	00090463          	beqz	s2,800044c4 <argfd+0x46>
    *pfd = fd;
    800044c0:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044c4:	4501                	li	a0,0
  if(pf)
    800044c6:	c091                	beqz	s1,800044ca <argfd+0x4c>
    *pf = f;
    800044c8:	e09c                	sd	a5,0(s1)
}
    800044ca:	70a2                	ld	ra,40(sp)
    800044cc:	7402                	ld	s0,32(sp)
    800044ce:	64e2                	ld	s1,24(sp)
    800044d0:	6942                	ld	s2,16(sp)
    800044d2:	6145                	addi	sp,sp,48
    800044d4:	8082                	ret
    return -1;
    800044d6:	557d                	li	a0,-1
    800044d8:	bfcd                	j	800044ca <argfd+0x4c>
    800044da:	557d                	li	a0,-1
    800044dc:	b7fd                	j	800044ca <argfd+0x4c>

00000000800044de <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044de:	1101                	addi	sp,sp,-32
    800044e0:	ec06                	sd	ra,24(sp)
    800044e2:	e822                	sd	s0,16(sp)
    800044e4:	e426                	sd	s1,8(sp)
    800044e6:	1000                	addi	s0,sp,32
    800044e8:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044ea:	ffffd097          	auipc	ra,0xffffd
    800044ee:	96e080e7          	jalr	-1682(ra) # 80000e58 <myproc>
    800044f2:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044f4:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffdd220>
    800044f8:	4501                	li	a0,0
    800044fa:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044fc:	6398                	ld	a4,0(a5)
    800044fe:	cb19                	beqz	a4,80004514 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004500:	2505                	addiw	a0,a0,1
    80004502:	07a1                	addi	a5,a5,8
    80004504:	fed51ce3          	bne	a0,a3,800044fc <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004508:	557d                	li	a0,-1
}
    8000450a:	60e2                	ld	ra,24(sp)
    8000450c:	6442                	ld	s0,16(sp)
    8000450e:	64a2                	ld	s1,8(sp)
    80004510:	6105                	addi	sp,sp,32
    80004512:	8082                	ret
      p->ofile[fd] = f;
    80004514:	01a50793          	addi	a5,a0,26
    80004518:	078e                	slli	a5,a5,0x3
    8000451a:	963e                	add	a2,a2,a5
    8000451c:	e204                	sd	s1,0(a2)
      return fd;
    8000451e:	b7f5                	j	8000450a <fdalloc+0x2c>

0000000080004520 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004520:	715d                	addi	sp,sp,-80
    80004522:	e486                	sd	ra,72(sp)
    80004524:	e0a2                	sd	s0,64(sp)
    80004526:	fc26                	sd	s1,56(sp)
    80004528:	f84a                	sd	s2,48(sp)
    8000452a:	f44e                	sd	s3,40(sp)
    8000452c:	f052                	sd	s4,32(sp)
    8000452e:	ec56                	sd	s5,24(sp)
    80004530:	e85a                	sd	s6,16(sp)
    80004532:	0880                	addi	s0,sp,80
    80004534:	8b2e                	mv	s6,a1
    80004536:	89b2                	mv	s3,a2
    80004538:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000453a:	fb040593          	addi	a1,s0,-80
    8000453e:	fffff097          	auipc	ra,0xfffff
    80004542:	e4e080e7          	jalr	-434(ra) # 8000338c <nameiparent>
    80004546:	84aa                	mv	s1,a0
    80004548:	16050063          	beqz	a0,800046a8 <create+0x188>
    return 0;

  ilock(dp);
    8000454c:	ffffe097          	auipc	ra,0xffffe
    80004550:	67c080e7          	jalr	1660(ra) # 80002bc8 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004554:	4601                	li	a2,0
    80004556:	fb040593          	addi	a1,s0,-80
    8000455a:	8526                	mv	a0,s1
    8000455c:	fffff097          	auipc	ra,0xfffff
    80004560:	b50080e7          	jalr	-1200(ra) # 800030ac <dirlookup>
    80004564:	8aaa                	mv	s5,a0
    80004566:	c931                	beqz	a0,800045ba <create+0x9a>
    iunlockput(dp);
    80004568:	8526                	mv	a0,s1
    8000456a:	fffff097          	auipc	ra,0xfffff
    8000456e:	8c0080e7          	jalr	-1856(ra) # 80002e2a <iunlockput>
    ilock(ip);
    80004572:	8556                	mv	a0,s5
    80004574:	ffffe097          	auipc	ra,0xffffe
    80004578:	654080e7          	jalr	1620(ra) # 80002bc8 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000457c:	000b059b          	sext.w	a1,s6
    80004580:	4789                	li	a5,2
    80004582:	02f59563          	bne	a1,a5,800045ac <create+0x8c>
    80004586:	044ad783          	lhu	a5,68(s5)
    8000458a:	37f9                	addiw	a5,a5,-2
    8000458c:	17c2                	slli	a5,a5,0x30
    8000458e:	93c1                	srli	a5,a5,0x30
    80004590:	4705                	li	a4,1
    80004592:	00f76d63          	bltu	a4,a5,800045ac <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004596:	8556                	mv	a0,s5
    80004598:	60a6                	ld	ra,72(sp)
    8000459a:	6406                	ld	s0,64(sp)
    8000459c:	74e2                	ld	s1,56(sp)
    8000459e:	7942                	ld	s2,48(sp)
    800045a0:	79a2                	ld	s3,40(sp)
    800045a2:	7a02                	ld	s4,32(sp)
    800045a4:	6ae2                	ld	s5,24(sp)
    800045a6:	6b42                	ld	s6,16(sp)
    800045a8:	6161                	addi	sp,sp,80
    800045aa:	8082                	ret
    iunlockput(ip);
    800045ac:	8556                	mv	a0,s5
    800045ae:	fffff097          	auipc	ra,0xfffff
    800045b2:	87c080e7          	jalr	-1924(ra) # 80002e2a <iunlockput>
    return 0;
    800045b6:	4a81                	li	s5,0
    800045b8:	bff9                	j	80004596 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    800045ba:	85da                	mv	a1,s6
    800045bc:	4088                	lw	a0,0(s1)
    800045be:	ffffe097          	auipc	ra,0xffffe
    800045c2:	46e080e7          	jalr	1134(ra) # 80002a2c <ialloc>
    800045c6:	8a2a                	mv	s4,a0
    800045c8:	c921                	beqz	a0,80004618 <create+0xf8>
  ilock(ip);
    800045ca:	ffffe097          	auipc	ra,0xffffe
    800045ce:	5fe080e7          	jalr	1534(ra) # 80002bc8 <ilock>
  ip->major = major;
    800045d2:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800045d6:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800045da:	4785                	li	a5,1
    800045dc:	04fa1523          	sh	a5,74(s4)
  iupdate(ip);
    800045e0:	8552                	mv	a0,s4
    800045e2:	ffffe097          	auipc	ra,0xffffe
    800045e6:	51c080e7          	jalr	1308(ra) # 80002afe <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045ea:	000b059b          	sext.w	a1,s6
    800045ee:	4785                	li	a5,1
    800045f0:	02f58b63          	beq	a1,a5,80004626 <create+0x106>
  if(dirlink(dp, name, ip->inum) < 0)
    800045f4:	004a2603          	lw	a2,4(s4)
    800045f8:	fb040593          	addi	a1,s0,-80
    800045fc:	8526                	mv	a0,s1
    800045fe:	fffff097          	auipc	ra,0xfffff
    80004602:	cbe080e7          	jalr	-834(ra) # 800032bc <dirlink>
    80004606:	06054f63          	bltz	a0,80004684 <create+0x164>
  iunlockput(dp);
    8000460a:	8526                	mv	a0,s1
    8000460c:	fffff097          	auipc	ra,0xfffff
    80004610:	81e080e7          	jalr	-2018(ra) # 80002e2a <iunlockput>
  return ip;
    80004614:	8ad2                	mv	s5,s4
    80004616:	b741                	j	80004596 <create+0x76>
    iunlockput(dp);
    80004618:	8526                	mv	a0,s1
    8000461a:	fffff097          	auipc	ra,0xfffff
    8000461e:	810080e7          	jalr	-2032(ra) # 80002e2a <iunlockput>
    return 0;
    80004622:	8ad2                	mv	s5,s4
    80004624:	bf8d                	j	80004596 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004626:	004a2603          	lw	a2,4(s4)
    8000462a:	00004597          	auipc	a1,0x4
    8000462e:	1be58593          	addi	a1,a1,446 # 800087e8 <syscallnames+0x2a0>
    80004632:	8552                	mv	a0,s4
    80004634:	fffff097          	auipc	ra,0xfffff
    80004638:	c88080e7          	jalr	-888(ra) # 800032bc <dirlink>
    8000463c:	04054463          	bltz	a0,80004684 <create+0x164>
    80004640:	40d0                	lw	a2,4(s1)
    80004642:	00004597          	auipc	a1,0x4
    80004646:	1ae58593          	addi	a1,a1,430 # 800087f0 <syscallnames+0x2a8>
    8000464a:	8552                	mv	a0,s4
    8000464c:	fffff097          	auipc	ra,0xfffff
    80004650:	c70080e7          	jalr	-912(ra) # 800032bc <dirlink>
    80004654:	02054863          	bltz	a0,80004684 <create+0x164>
  if(dirlink(dp, name, ip->inum) < 0)
    80004658:	004a2603          	lw	a2,4(s4)
    8000465c:	fb040593          	addi	a1,s0,-80
    80004660:	8526                	mv	a0,s1
    80004662:	fffff097          	auipc	ra,0xfffff
    80004666:	c5a080e7          	jalr	-934(ra) # 800032bc <dirlink>
    8000466a:	00054d63          	bltz	a0,80004684 <create+0x164>
    dp->nlink++;  // for ".."
    8000466e:	04a4d783          	lhu	a5,74(s1)
    80004672:	2785                	addiw	a5,a5,1
    80004674:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004678:	8526                	mv	a0,s1
    8000467a:	ffffe097          	auipc	ra,0xffffe
    8000467e:	484080e7          	jalr	1156(ra) # 80002afe <iupdate>
    80004682:	b761                	j	8000460a <create+0xea>
  ip->nlink = 0;
    80004684:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004688:	8552                	mv	a0,s4
    8000468a:	ffffe097          	auipc	ra,0xffffe
    8000468e:	474080e7          	jalr	1140(ra) # 80002afe <iupdate>
  iunlockput(ip);
    80004692:	8552                	mv	a0,s4
    80004694:	ffffe097          	auipc	ra,0xffffe
    80004698:	796080e7          	jalr	1942(ra) # 80002e2a <iunlockput>
  iunlockput(dp);
    8000469c:	8526                	mv	a0,s1
    8000469e:	ffffe097          	auipc	ra,0xffffe
    800046a2:	78c080e7          	jalr	1932(ra) # 80002e2a <iunlockput>
  return 0;
    800046a6:	bdc5                	j	80004596 <create+0x76>
    return 0;
    800046a8:	8aaa                	mv	s5,a0
    800046aa:	b5f5                	j	80004596 <create+0x76>

00000000800046ac <sys_dup>:
{
    800046ac:	7179                	addi	sp,sp,-48
    800046ae:	f406                	sd	ra,40(sp)
    800046b0:	f022                	sd	s0,32(sp)
    800046b2:	ec26                	sd	s1,24(sp)
    800046b4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800046b6:	fd840613          	addi	a2,s0,-40
    800046ba:	4581                	li	a1,0
    800046bc:	4501                	li	a0,0
    800046be:	00000097          	auipc	ra,0x0
    800046c2:	dc0080e7          	jalr	-576(ra) # 8000447e <argfd>
    return -1;
    800046c6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800046c8:	02054363          	bltz	a0,800046ee <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800046cc:	fd843503          	ld	a0,-40(s0)
    800046d0:	00000097          	auipc	ra,0x0
    800046d4:	e0e080e7          	jalr	-498(ra) # 800044de <fdalloc>
    800046d8:	84aa                	mv	s1,a0
    return -1;
    800046da:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800046dc:	00054963          	bltz	a0,800046ee <sys_dup+0x42>
  filedup(f);
    800046e0:	fd843503          	ld	a0,-40(s0)
    800046e4:	fffff097          	auipc	ra,0xfffff
    800046e8:	320080e7          	jalr	800(ra) # 80003a04 <filedup>
  return fd;
    800046ec:	87a6                	mv	a5,s1
}
    800046ee:	853e                	mv	a0,a5
    800046f0:	70a2                	ld	ra,40(sp)
    800046f2:	7402                	ld	s0,32(sp)
    800046f4:	64e2                	ld	s1,24(sp)
    800046f6:	6145                	addi	sp,sp,48
    800046f8:	8082                	ret

00000000800046fa <sys_read>:
{
    800046fa:	7179                	addi	sp,sp,-48
    800046fc:	f406                	sd	ra,40(sp)
    800046fe:	f022                	sd	s0,32(sp)
    80004700:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004702:	fd840593          	addi	a1,s0,-40
    80004706:	4505                	li	a0,1
    80004708:	ffffe097          	auipc	ra,0xffffe
    8000470c:	8fc080e7          	jalr	-1796(ra) # 80002004 <argaddr>
  argint(2, &n);
    80004710:	fe440593          	addi	a1,s0,-28
    80004714:	4509                	li	a0,2
    80004716:	ffffe097          	auipc	ra,0xffffe
    8000471a:	8ce080e7          	jalr	-1842(ra) # 80001fe4 <argint>
  if(argfd(0, 0, &f) < 0)
    8000471e:	fe840613          	addi	a2,s0,-24
    80004722:	4581                	li	a1,0
    80004724:	4501                	li	a0,0
    80004726:	00000097          	auipc	ra,0x0
    8000472a:	d58080e7          	jalr	-680(ra) # 8000447e <argfd>
    8000472e:	87aa                	mv	a5,a0
    return -1;
    80004730:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004732:	0007cc63          	bltz	a5,8000474a <sys_read+0x50>
  return fileread(f, p, n);
    80004736:	fe442603          	lw	a2,-28(s0)
    8000473a:	fd843583          	ld	a1,-40(s0)
    8000473e:	fe843503          	ld	a0,-24(s0)
    80004742:	fffff097          	auipc	ra,0xfffff
    80004746:	44e080e7          	jalr	1102(ra) # 80003b90 <fileread>
}
    8000474a:	70a2                	ld	ra,40(sp)
    8000474c:	7402                	ld	s0,32(sp)
    8000474e:	6145                	addi	sp,sp,48
    80004750:	8082                	ret

0000000080004752 <sys_write>:
{
    80004752:	7179                	addi	sp,sp,-48
    80004754:	f406                	sd	ra,40(sp)
    80004756:	f022                	sd	s0,32(sp)
    80004758:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000475a:	fd840593          	addi	a1,s0,-40
    8000475e:	4505                	li	a0,1
    80004760:	ffffe097          	auipc	ra,0xffffe
    80004764:	8a4080e7          	jalr	-1884(ra) # 80002004 <argaddr>
  argint(2, &n);
    80004768:	fe440593          	addi	a1,s0,-28
    8000476c:	4509                	li	a0,2
    8000476e:	ffffe097          	auipc	ra,0xffffe
    80004772:	876080e7          	jalr	-1930(ra) # 80001fe4 <argint>
  if(argfd(0, 0, &f) < 0)
    80004776:	fe840613          	addi	a2,s0,-24
    8000477a:	4581                	li	a1,0
    8000477c:	4501                	li	a0,0
    8000477e:	00000097          	auipc	ra,0x0
    80004782:	d00080e7          	jalr	-768(ra) # 8000447e <argfd>
    80004786:	87aa                	mv	a5,a0
    return -1;
    80004788:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000478a:	0007cc63          	bltz	a5,800047a2 <sys_write+0x50>
  return filewrite(f, p, n);
    8000478e:	fe442603          	lw	a2,-28(s0)
    80004792:	fd843583          	ld	a1,-40(s0)
    80004796:	fe843503          	ld	a0,-24(s0)
    8000479a:	fffff097          	auipc	ra,0xfffff
    8000479e:	4b8080e7          	jalr	1208(ra) # 80003c52 <filewrite>
}
    800047a2:	70a2                	ld	ra,40(sp)
    800047a4:	7402                	ld	s0,32(sp)
    800047a6:	6145                	addi	sp,sp,48
    800047a8:	8082                	ret

00000000800047aa <sys_close>:
{
    800047aa:	1101                	addi	sp,sp,-32
    800047ac:	ec06                	sd	ra,24(sp)
    800047ae:	e822                	sd	s0,16(sp)
    800047b0:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800047b2:	fe040613          	addi	a2,s0,-32
    800047b6:	fec40593          	addi	a1,s0,-20
    800047ba:	4501                	li	a0,0
    800047bc:	00000097          	auipc	ra,0x0
    800047c0:	cc2080e7          	jalr	-830(ra) # 8000447e <argfd>
    return -1;
    800047c4:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047c6:	02054463          	bltz	a0,800047ee <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047ca:	ffffc097          	auipc	ra,0xffffc
    800047ce:	68e080e7          	jalr	1678(ra) # 80000e58 <myproc>
    800047d2:	fec42783          	lw	a5,-20(s0)
    800047d6:	07e9                	addi	a5,a5,26
    800047d8:	078e                	slli	a5,a5,0x3
    800047da:	97aa                	add	a5,a5,a0
    800047dc:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800047e0:	fe043503          	ld	a0,-32(s0)
    800047e4:	fffff097          	auipc	ra,0xfffff
    800047e8:	272080e7          	jalr	626(ra) # 80003a56 <fileclose>
  return 0;
    800047ec:	4781                	li	a5,0
}
    800047ee:	853e                	mv	a0,a5
    800047f0:	60e2                	ld	ra,24(sp)
    800047f2:	6442                	ld	s0,16(sp)
    800047f4:	6105                	addi	sp,sp,32
    800047f6:	8082                	ret

00000000800047f8 <sys_fstat>:
{
    800047f8:	1101                	addi	sp,sp,-32
    800047fa:	ec06                	sd	ra,24(sp)
    800047fc:	e822                	sd	s0,16(sp)
    800047fe:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004800:	fe040593          	addi	a1,s0,-32
    80004804:	4505                	li	a0,1
    80004806:	ffffd097          	auipc	ra,0xffffd
    8000480a:	7fe080e7          	jalr	2046(ra) # 80002004 <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000480e:	fe840613          	addi	a2,s0,-24
    80004812:	4581                	li	a1,0
    80004814:	4501                	li	a0,0
    80004816:	00000097          	auipc	ra,0x0
    8000481a:	c68080e7          	jalr	-920(ra) # 8000447e <argfd>
    8000481e:	87aa                	mv	a5,a0
    return -1;
    80004820:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004822:	0007ca63          	bltz	a5,80004836 <sys_fstat+0x3e>
  return filestat(f, st);
    80004826:	fe043583          	ld	a1,-32(s0)
    8000482a:	fe843503          	ld	a0,-24(s0)
    8000482e:	fffff097          	auipc	ra,0xfffff
    80004832:	2f0080e7          	jalr	752(ra) # 80003b1e <filestat>
}
    80004836:	60e2                	ld	ra,24(sp)
    80004838:	6442                	ld	s0,16(sp)
    8000483a:	6105                	addi	sp,sp,32
    8000483c:	8082                	ret

000000008000483e <sys_link>:
{
    8000483e:	7169                	addi	sp,sp,-304
    80004840:	f606                	sd	ra,296(sp)
    80004842:	f222                	sd	s0,288(sp)
    80004844:	ee26                	sd	s1,280(sp)
    80004846:	ea4a                	sd	s2,272(sp)
    80004848:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000484a:	08000613          	li	a2,128
    8000484e:	ed040593          	addi	a1,s0,-304
    80004852:	4501                	li	a0,0
    80004854:	ffffd097          	auipc	ra,0xffffd
    80004858:	7d0080e7          	jalr	2000(ra) # 80002024 <argstr>
    return -1;
    8000485c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000485e:	10054e63          	bltz	a0,8000497a <sys_link+0x13c>
    80004862:	08000613          	li	a2,128
    80004866:	f5040593          	addi	a1,s0,-176
    8000486a:	4505                	li	a0,1
    8000486c:	ffffd097          	auipc	ra,0xffffd
    80004870:	7b8080e7          	jalr	1976(ra) # 80002024 <argstr>
    return -1;
    80004874:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004876:	10054263          	bltz	a0,8000497a <sys_link+0x13c>
  begin_op();
    8000487a:	fffff097          	auipc	ra,0xfffff
    8000487e:	d10080e7          	jalr	-752(ra) # 8000358a <begin_op>
  if((ip = namei(old)) == 0){
    80004882:	ed040513          	addi	a0,s0,-304
    80004886:	fffff097          	auipc	ra,0xfffff
    8000488a:	ae8080e7          	jalr	-1304(ra) # 8000336e <namei>
    8000488e:	84aa                	mv	s1,a0
    80004890:	c551                	beqz	a0,8000491c <sys_link+0xde>
  ilock(ip);
    80004892:	ffffe097          	auipc	ra,0xffffe
    80004896:	336080e7          	jalr	822(ra) # 80002bc8 <ilock>
  if(ip->type == T_DIR){
    8000489a:	04449703          	lh	a4,68(s1)
    8000489e:	4785                	li	a5,1
    800048a0:	08f70463          	beq	a4,a5,80004928 <sys_link+0xea>
  ip->nlink++;
    800048a4:	04a4d783          	lhu	a5,74(s1)
    800048a8:	2785                	addiw	a5,a5,1
    800048aa:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048ae:	8526                	mv	a0,s1
    800048b0:	ffffe097          	auipc	ra,0xffffe
    800048b4:	24e080e7          	jalr	590(ra) # 80002afe <iupdate>
  iunlock(ip);
    800048b8:	8526                	mv	a0,s1
    800048ba:	ffffe097          	auipc	ra,0xffffe
    800048be:	3d0080e7          	jalr	976(ra) # 80002c8a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048c2:	fd040593          	addi	a1,s0,-48
    800048c6:	f5040513          	addi	a0,s0,-176
    800048ca:	fffff097          	auipc	ra,0xfffff
    800048ce:	ac2080e7          	jalr	-1342(ra) # 8000338c <nameiparent>
    800048d2:	892a                	mv	s2,a0
    800048d4:	c935                	beqz	a0,80004948 <sys_link+0x10a>
  ilock(dp);
    800048d6:	ffffe097          	auipc	ra,0xffffe
    800048da:	2f2080e7          	jalr	754(ra) # 80002bc8 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048de:	00092703          	lw	a4,0(s2)
    800048e2:	409c                	lw	a5,0(s1)
    800048e4:	04f71d63          	bne	a4,a5,8000493e <sys_link+0x100>
    800048e8:	40d0                	lw	a2,4(s1)
    800048ea:	fd040593          	addi	a1,s0,-48
    800048ee:	854a                	mv	a0,s2
    800048f0:	fffff097          	auipc	ra,0xfffff
    800048f4:	9cc080e7          	jalr	-1588(ra) # 800032bc <dirlink>
    800048f8:	04054363          	bltz	a0,8000493e <sys_link+0x100>
  iunlockput(dp);
    800048fc:	854a                	mv	a0,s2
    800048fe:	ffffe097          	auipc	ra,0xffffe
    80004902:	52c080e7          	jalr	1324(ra) # 80002e2a <iunlockput>
  iput(ip);
    80004906:	8526                	mv	a0,s1
    80004908:	ffffe097          	auipc	ra,0xffffe
    8000490c:	47a080e7          	jalr	1146(ra) # 80002d82 <iput>
  end_op();
    80004910:	fffff097          	auipc	ra,0xfffff
    80004914:	cfa080e7          	jalr	-774(ra) # 8000360a <end_op>
  return 0;
    80004918:	4781                	li	a5,0
    8000491a:	a085                	j	8000497a <sys_link+0x13c>
    end_op();
    8000491c:	fffff097          	auipc	ra,0xfffff
    80004920:	cee080e7          	jalr	-786(ra) # 8000360a <end_op>
    return -1;
    80004924:	57fd                	li	a5,-1
    80004926:	a891                	j	8000497a <sys_link+0x13c>
    iunlockput(ip);
    80004928:	8526                	mv	a0,s1
    8000492a:	ffffe097          	auipc	ra,0xffffe
    8000492e:	500080e7          	jalr	1280(ra) # 80002e2a <iunlockput>
    end_op();
    80004932:	fffff097          	auipc	ra,0xfffff
    80004936:	cd8080e7          	jalr	-808(ra) # 8000360a <end_op>
    return -1;
    8000493a:	57fd                	li	a5,-1
    8000493c:	a83d                	j	8000497a <sys_link+0x13c>
    iunlockput(dp);
    8000493e:	854a                	mv	a0,s2
    80004940:	ffffe097          	auipc	ra,0xffffe
    80004944:	4ea080e7          	jalr	1258(ra) # 80002e2a <iunlockput>
  ilock(ip);
    80004948:	8526                	mv	a0,s1
    8000494a:	ffffe097          	auipc	ra,0xffffe
    8000494e:	27e080e7          	jalr	638(ra) # 80002bc8 <ilock>
  ip->nlink--;
    80004952:	04a4d783          	lhu	a5,74(s1)
    80004956:	37fd                	addiw	a5,a5,-1
    80004958:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000495c:	8526                	mv	a0,s1
    8000495e:	ffffe097          	auipc	ra,0xffffe
    80004962:	1a0080e7          	jalr	416(ra) # 80002afe <iupdate>
  iunlockput(ip);
    80004966:	8526                	mv	a0,s1
    80004968:	ffffe097          	auipc	ra,0xffffe
    8000496c:	4c2080e7          	jalr	1218(ra) # 80002e2a <iunlockput>
  end_op();
    80004970:	fffff097          	auipc	ra,0xfffff
    80004974:	c9a080e7          	jalr	-870(ra) # 8000360a <end_op>
  return -1;
    80004978:	57fd                	li	a5,-1
}
    8000497a:	853e                	mv	a0,a5
    8000497c:	70b2                	ld	ra,296(sp)
    8000497e:	7412                	ld	s0,288(sp)
    80004980:	64f2                	ld	s1,280(sp)
    80004982:	6952                	ld	s2,272(sp)
    80004984:	6155                	addi	sp,sp,304
    80004986:	8082                	ret

0000000080004988 <sys_unlink>:
{
    80004988:	7151                	addi	sp,sp,-240
    8000498a:	f586                	sd	ra,232(sp)
    8000498c:	f1a2                	sd	s0,224(sp)
    8000498e:	eda6                	sd	s1,216(sp)
    80004990:	e9ca                	sd	s2,208(sp)
    80004992:	e5ce                	sd	s3,200(sp)
    80004994:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004996:	08000613          	li	a2,128
    8000499a:	f3040593          	addi	a1,s0,-208
    8000499e:	4501                	li	a0,0
    800049a0:	ffffd097          	auipc	ra,0xffffd
    800049a4:	684080e7          	jalr	1668(ra) # 80002024 <argstr>
    800049a8:	18054163          	bltz	a0,80004b2a <sys_unlink+0x1a2>
  begin_op();
    800049ac:	fffff097          	auipc	ra,0xfffff
    800049b0:	bde080e7          	jalr	-1058(ra) # 8000358a <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800049b4:	fb040593          	addi	a1,s0,-80
    800049b8:	f3040513          	addi	a0,s0,-208
    800049bc:	fffff097          	auipc	ra,0xfffff
    800049c0:	9d0080e7          	jalr	-1584(ra) # 8000338c <nameiparent>
    800049c4:	84aa                	mv	s1,a0
    800049c6:	c979                	beqz	a0,80004a9c <sys_unlink+0x114>
  ilock(dp);
    800049c8:	ffffe097          	auipc	ra,0xffffe
    800049cc:	200080e7          	jalr	512(ra) # 80002bc8 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049d0:	00004597          	auipc	a1,0x4
    800049d4:	e1858593          	addi	a1,a1,-488 # 800087e8 <syscallnames+0x2a0>
    800049d8:	fb040513          	addi	a0,s0,-80
    800049dc:	ffffe097          	auipc	ra,0xffffe
    800049e0:	6b6080e7          	jalr	1718(ra) # 80003092 <namecmp>
    800049e4:	14050a63          	beqz	a0,80004b38 <sys_unlink+0x1b0>
    800049e8:	00004597          	auipc	a1,0x4
    800049ec:	e0858593          	addi	a1,a1,-504 # 800087f0 <syscallnames+0x2a8>
    800049f0:	fb040513          	addi	a0,s0,-80
    800049f4:	ffffe097          	auipc	ra,0xffffe
    800049f8:	69e080e7          	jalr	1694(ra) # 80003092 <namecmp>
    800049fc:	12050e63          	beqz	a0,80004b38 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a00:	f2c40613          	addi	a2,s0,-212
    80004a04:	fb040593          	addi	a1,s0,-80
    80004a08:	8526                	mv	a0,s1
    80004a0a:	ffffe097          	auipc	ra,0xffffe
    80004a0e:	6a2080e7          	jalr	1698(ra) # 800030ac <dirlookup>
    80004a12:	892a                	mv	s2,a0
    80004a14:	12050263          	beqz	a0,80004b38 <sys_unlink+0x1b0>
  ilock(ip);
    80004a18:	ffffe097          	auipc	ra,0xffffe
    80004a1c:	1b0080e7          	jalr	432(ra) # 80002bc8 <ilock>
  if(ip->nlink < 1)
    80004a20:	04a91783          	lh	a5,74(s2)
    80004a24:	08f05263          	blez	a5,80004aa8 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a28:	04491703          	lh	a4,68(s2)
    80004a2c:	4785                	li	a5,1
    80004a2e:	08f70563          	beq	a4,a5,80004ab8 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a32:	4641                	li	a2,16
    80004a34:	4581                	li	a1,0
    80004a36:	fc040513          	addi	a0,s0,-64
    80004a3a:	ffffb097          	auipc	ra,0xffffb
    80004a3e:	73e080e7          	jalr	1854(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a42:	4741                	li	a4,16
    80004a44:	f2c42683          	lw	a3,-212(s0)
    80004a48:	fc040613          	addi	a2,s0,-64
    80004a4c:	4581                	li	a1,0
    80004a4e:	8526                	mv	a0,s1
    80004a50:	ffffe097          	auipc	ra,0xffffe
    80004a54:	524080e7          	jalr	1316(ra) # 80002f74 <writei>
    80004a58:	47c1                	li	a5,16
    80004a5a:	0af51563          	bne	a0,a5,80004b04 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a5e:	04491703          	lh	a4,68(s2)
    80004a62:	4785                	li	a5,1
    80004a64:	0af70863          	beq	a4,a5,80004b14 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a68:	8526                	mv	a0,s1
    80004a6a:	ffffe097          	auipc	ra,0xffffe
    80004a6e:	3c0080e7          	jalr	960(ra) # 80002e2a <iunlockput>
  ip->nlink--;
    80004a72:	04a95783          	lhu	a5,74(s2)
    80004a76:	37fd                	addiw	a5,a5,-1
    80004a78:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a7c:	854a                	mv	a0,s2
    80004a7e:	ffffe097          	auipc	ra,0xffffe
    80004a82:	080080e7          	jalr	128(ra) # 80002afe <iupdate>
  iunlockput(ip);
    80004a86:	854a                	mv	a0,s2
    80004a88:	ffffe097          	auipc	ra,0xffffe
    80004a8c:	3a2080e7          	jalr	930(ra) # 80002e2a <iunlockput>
  end_op();
    80004a90:	fffff097          	auipc	ra,0xfffff
    80004a94:	b7a080e7          	jalr	-1158(ra) # 8000360a <end_op>
  return 0;
    80004a98:	4501                	li	a0,0
    80004a9a:	a84d                	j	80004b4c <sys_unlink+0x1c4>
    end_op();
    80004a9c:	fffff097          	auipc	ra,0xfffff
    80004aa0:	b6e080e7          	jalr	-1170(ra) # 8000360a <end_op>
    return -1;
    80004aa4:	557d                	li	a0,-1
    80004aa6:	a05d                	j	80004b4c <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004aa8:	00004517          	auipc	a0,0x4
    80004aac:	d5050513          	addi	a0,a0,-688 # 800087f8 <syscallnames+0x2b0>
    80004ab0:	00001097          	auipc	ra,0x1
    80004ab4:	212080e7          	jalr	530(ra) # 80005cc2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ab8:	04c92703          	lw	a4,76(s2)
    80004abc:	02000793          	li	a5,32
    80004ac0:	f6e7f9e3          	bgeu	a5,a4,80004a32 <sys_unlink+0xaa>
    80004ac4:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ac8:	4741                	li	a4,16
    80004aca:	86ce                	mv	a3,s3
    80004acc:	f1840613          	addi	a2,s0,-232
    80004ad0:	4581                	li	a1,0
    80004ad2:	854a                	mv	a0,s2
    80004ad4:	ffffe097          	auipc	ra,0xffffe
    80004ad8:	3a8080e7          	jalr	936(ra) # 80002e7c <readi>
    80004adc:	47c1                	li	a5,16
    80004ade:	00f51b63          	bne	a0,a5,80004af4 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004ae2:	f1845783          	lhu	a5,-232(s0)
    80004ae6:	e7a1                	bnez	a5,80004b2e <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ae8:	29c1                	addiw	s3,s3,16
    80004aea:	04c92783          	lw	a5,76(s2)
    80004aee:	fcf9ede3          	bltu	s3,a5,80004ac8 <sys_unlink+0x140>
    80004af2:	b781                	j	80004a32 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004af4:	00004517          	auipc	a0,0x4
    80004af8:	d1c50513          	addi	a0,a0,-740 # 80008810 <syscallnames+0x2c8>
    80004afc:	00001097          	auipc	ra,0x1
    80004b00:	1c6080e7          	jalr	454(ra) # 80005cc2 <panic>
    panic("unlink: writei");
    80004b04:	00004517          	auipc	a0,0x4
    80004b08:	d2450513          	addi	a0,a0,-732 # 80008828 <syscallnames+0x2e0>
    80004b0c:	00001097          	auipc	ra,0x1
    80004b10:	1b6080e7          	jalr	438(ra) # 80005cc2 <panic>
    dp->nlink--;
    80004b14:	04a4d783          	lhu	a5,74(s1)
    80004b18:	37fd                	addiw	a5,a5,-1
    80004b1a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b1e:	8526                	mv	a0,s1
    80004b20:	ffffe097          	auipc	ra,0xffffe
    80004b24:	fde080e7          	jalr	-34(ra) # 80002afe <iupdate>
    80004b28:	b781                	j	80004a68 <sys_unlink+0xe0>
    return -1;
    80004b2a:	557d                	li	a0,-1
    80004b2c:	a005                	j	80004b4c <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b2e:	854a                	mv	a0,s2
    80004b30:	ffffe097          	auipc	ra,0xffffe
    80004b34:	2fa080e7          	jalr	762(ra) # 80002e2a <iunlockput>
  iunlockput(dp);
    80004b38:	8526                	mv	a0,s1
    80004b3a:	ffffe097          	auipc	ra,0xffffe
    80004b3e:	2f0080e7          	jalr	752(ra) # 80002e2a <iunlockput>
  end_op();
    80004b42:	fffff097          	auipc	ra,0xfffff
    80004b46:	ac8080e7          	jalr	-1336(ra) # 8000360a <end_op>
  return -1;
    80004b4a:	557d                	li	a0,-1
}
    80004b4c:	70ae                	ld	ra,232(sp)
    80004b4e:	740e                	ld	s0,224(sp)
    80004b50:	64ee                	ld	s1,216(sp)
    80004b52:	694e                	ld	s2,208(sp)
    80004b54:	69ae                	ld	s3,200(sp)
    80004b56:	616d                	addi	sp,sp,240
    80004b58:	8082                	ret

0000000080004b5a <sys_open>:

uint64
sys_open(void)
{
    80004b5a:	7131                	addi	sp,sp,-192
    80004b5c:	fd06                	sd	ra,184(sp)
    80004b5e:	f922                	sd	s0,176(sp)
    80004b60:	f526                	sd	s1,168(sp)
    80004b62:	f14a                	sd	s2,160(sp)
    80004b64:	ed4e                	sd	s3,152(sp)
    80004b66:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004b68:	f4c40593          	addi	a1,s0,-180
    80004b6c:	4505                	li	a0,1
    80004b6e:	ffffd097          	auipc	ra,0xffffd
    80004b72:	476080e7          	jalr	1142(ra) # 80001fe4 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004b76:	08000613          	li	a2,128
    80004b7a:	f5040593          	addi	a1,s0,-176
    80004b7e:	4501                	li	a0,0
    80004b80:	ffffd097          	auipc	ra,0xffffd
    80004b84:	4a4080e7          	jalr	1188(ra) # 80002024 <argstr>
    80004b88:	87aa                	mv	a5,a0
    return -1;
    80004b8a:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004b8c:	0a07c963          	bltz	a5,80004c3e <sys_open+0xe4>

  begin_op();
    80004b90:	fffff097          	auipc	ra,0xfffff
    80004b94:	9fa080e7          	jalr	-1542(ra) # 8000358a <begin_op>

  if(omode & O_CREATE){
    80004b98:	f4c42783          	lw	a5,-180(s0)
    80004b9c:	2007f793          	andi	a5,a5,512
    80004ba0:	cfc5                	beqz	a5,80004c58 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004ba2:	4681                	li	a3,0
    80004ba4:	4601                	li	a2,0
    80004ba6:	4589                	li	a1,2
    80004ba8:	f5040513          	addi	a0,s0,-176
    80004bac:	00000097          	auipc	ra,0x0
    80004bb0:	974080e7          	jalr	-1676(ra) # 80004520 <create>
    80004bb4:	84aa                	mv	s1,a0
    if(ip == 0){
    80004bb6:	c959                	beqz	a0,80004c4c <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004bb8:	04449703          	lh	a4,68(s1)
    80004bbc:	478d                	li	a5,3
    80004bbe:	00f71763          	bne	a4,a5,80004bcc <sys_open+0x72>
    80004bc2:	0464d703          	lhu	a4,70(s1)
    80004bc6:	47a5                	li	a5,9
    80004bc8:	0ce7ed63          	bltu	a5,a4,80004ca2 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004bcc:	fffff097          	auipc	ra,0xfffff
    80004bd0:	dce080e7          	jalr	-562(ra) # 8000399a <filealloc>
    80004bd4:	89aa                	mv	s3,a0
    80004bd6:	10050363          	beqz	a0,80004cdc <sys_open+0x182>
    80004bda:	00000097          	auipc	ra,0x0
    80004bde:	904080e7          	jalr	-1788(ra) # 800044de <fdalloc>
    80004be2:	892a                	mv	s2,a0
    80004be4:	0e054763          	bltz	a0,80004cd2 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004be8:	04449703          	lh	a4,68(s1)
    80004bec:	478d                	li	a5,3
    80004bee:	0cf70563          	beq	a4,a5,80004cb8 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004bf2:	4789                	li	a5,2
    80004bf4:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004bf8:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004bfc:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004c00:	f4c42783          	lw	a5,-180(s0)
    80004c04:	0017c713          	xori	a4,a5,1
    80004c08:	8b05                	andi	a4,a4,1
    80004c0a:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c0e:	0037f713          	andi	a4,a5,3
    80004c12:	00e03733          	snez	a4,a4
    80004c16:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c1a:	4007f793          	andi	a5,a5,1024
    80004c1e:	c791                	beqz	a5,80004c2a <sys_open+0xd0>
    80004c20:	04449703          	lh	a4,68(s1)
    80004c24:	4789                	li	a5,2
    80004c26:	0af70063          	beq	a4,a5,80004cc6 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004c2a:	8526                	mv	a0,s1
    80004c2c:	ffffe097          	auipc	ra,0xffffe
    80004c30:	05e080e7          	jalr	94(ra) # 80002c8a <iunlock>
  end_op();
    80004c34:	fffff097          	auipc	ra,0xfffff
    80004c38:	9d6080e7          	jalr	-1578(ra) # 8000360a <end_op>

  return fd;
    80004c3c:	854a                	mv	a0,s2
}
    80004c3e:	70ea                	ld	ra,184(sp)
    80004c40:	744a                	ld	s0,176(sp)
    80004c42:	74aa                	ld	s1,168(sp)
    80004c44:	790a                	ld	s2,160(sp)
    80004c46:	69ea                	ld	s3,152(sp)
    80004c48:	6129                	addi	sp,sp,192
    80004c4a:	8082                	ret
      end_op();
    80004c4c:	fffff097          	auipc	ra,0xfffff
    80004c50:	9be080e7          	jalr	-1602(ra) # 8000360a <end_op>
      return -1;
    80004c54:	557d                	li	a0,-1
    80004c56:	b7e5                	j	80004c3e <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c58:	f5040513          	addi	a0,s0,-176
    80004c5c:	ffffe097          	auipc	ra,0xffffe
    80004c60:	712080e7          	jalr	1810(ra) # 8000336e <namei>
    80004c64:	84aa                	mv	s1,a0
    80004c66:	c905                	beqz	a0,80004c96 <sys_open+0x13c>
    ilock(ip);
    80004c68:	ffffe097          	auipc	ra,0xffffe
    80004c6c:	f60080e7          	jalr	-160(ra) # 80002bc8 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c70:	04449703          	lh	a4,68(s1)
    80004c74:	4785                	li	a5,1
    80004c76:	f4f711e3          	bne	a4,a5,80004bb8 <sys_open+0x5e>
    80004c7a:	f4c42783          	lw	a5,-180(s0)
    80004c7e:	d7b9                	beqz	a5,80004bcc <sys_open+0x72>
      iunlockput(ip);
    80004c80:	8526                	mv	a0,s1
    80004c82:	ffffe097          	auipc	ra,0xffffe
    80004c86:	1a8080e7          	jalr	424(ra) # 80002e2a <iunlockput>
      end_op();
    80004c8a:	fffff097          	auipc	ra,0xfffff
    80004c8e:	980080e7          	jalr	-1664(ra) # 8000360a <end_op>
      return -1;
    80004c92:	557d                	li	a0,-1
    80004c94:	b76d                	j	80004c3e <sys_open+0xe4>
      end_op();
    80004c96:	fffff097          	auipc	ra,0xfffff
    80004c9a:	974080e7          	jalr	-1676(ra) # 8000360a <end_op>
      return -1;
    80004c9e:	557d                	li	a0,-1
    80004ca0:	bf79                	j	80004c3e <sys_open+0xe4>
    iunlockput(ip);
    80004ca2:	8526                	mv	a0,s1
    80004ca4:	ffffe097          	auipc	ra,0xffffe
    80004ca8:	186080e7          	jalr	390(ra) # 80002e2a <iunlockput>
    end_op();
    80004cac:	fffff097          	auipc	ra,0xfffff
    80004cb0:	95e080e7          	jalr	-1698(ra) # 8000360a <end_op>
    return -1;
    80004cb4:	557d                	li	a0,-1
    80004cb6:	b761                	j	80004c3e <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004cb8:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004cbc:	04649783          	lh	a5,70(s1)
    80004cc0:	02f99223          	sh	a5,36(s3)
    80004cc4:	bf25                	j	80004bfc <sys_open+0xa2>
    itrunc(ip);
    80004cc6:	8526                	mv	a0,s1
    80004cc8:	ffffe097          	auipc	ra,0xffffe
    80004ccc:	00e080e7          	jalr	14(ra) # 80002cd6 <itrunc>
    80004cd0:	bfa9                	j	80004c2a <sys_open+0xd0>
      fileclose(f);
    80004cd2:	854e                	mv	a0,s3
    80004cd4:	fffff097          	auipc	ra,0xfffff
    80004cd8:	d82080e7          	jalr	-638(ra) # 80003a56 <fileclose>
    iunlockput(ip);
    80004cdc:	8526                	mv	a0,s1
    80004cde:	ffffe097          	auipc	ra,0xffffe
    80004ce2:	14c080e7          	jalr	332(ra) # 80002e2a <iunlockput>
    end_op();
    80004ce6:	fffff097          	auipc	ra,0xfffff
    80004cea:	924080e7          	jalr	-1756(ra) # 8000360a <end_op>
    return -1;
    80004cee:	557d                	li	a0,-1
    80004cf0:	b7b9                	j	80004c3e <sys_open+0xe4>

0000000080004cf2 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004cf2:	7175                	addi	sp,sp,-144
    80004cf4:	e506                	sd	ra,136(sp)
    80004cf6:	e122                	sd	s0,128(sp)
    80004cf8:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004cfa:	fffff097          	auipc	ra,0xfffff
    80004cfe:	890080e7          	jalr	-1904(ra) # 8000358a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d02:	08000613          	li	a2,128
    80004d06:	f7040593          	addi	a1,s0,-144
    80004d0a:	4501                	li	a0,0
    80004d0c:	ffffd097          	auipc	ra,0xffffd
    80004d10:	318080e7          	jalr	792(ra) # 80002024 <argstr>
    80004d14:	02054963          	bltz	a0,80004d46 <sys_mkdir+0x54>
    80004d18:	4681                	li	a3,0
    80004d1a:	4601                	li	a2,0
    80004d1c:	4585                	li	a1,1
    80004d1e:	f7040513          	addi	a0,s0,-144
    80004d22:	fffff097          	auipc	ra,0xfffff
    80004d26:	7fe080e7          	jalr	2046(ra) # 80004520 <create>
    80004d2a:	cd11                	beqz	a0,80004d46 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d2c:	ffffe097          	auipc	ra,0xffffe
    80004d30:	0fe080e7          	jalr	254(ra) # 80002e2a <iunlockput>
  end_op();
    80004d34:	fffff097          	auipc	ra,0xfffff
    80004d38:	8d6080e7          	jalr	-1834(ra) # 8000360a <end_op>
  return 0;
    80004d3c:	4501                	li	a0,0
}
    80004d3e:	60aa                	ld	ra,136(sp)
    80004d40:	640a                	ld	s0,128(sp)
    80004d42:	6149                	addi	sp,sp,144
    80004d44:	8082                	ret
    end_op();
    80004d46:	fffff097          	auipc	ra,0xfffff
    80004d4a:	8c4080e7          	jalr	-1852(ra) # 8000360a <end_op>
    return -1;
    80004d4e:	557d                	li	a0,-1
    80004d50:	b7fd                	j	80004d3e <sys_mkdir+0x4c>

0000000080004d52 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d52:	7135                	addi	sp,sp,-160
    80004d54:	ed06                	sd	ra,152(sp)
    80004d56:	e922                	sd	s0,144(sp)
    80004d58:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d5a:	fffff097          	auipc	ra,0xfffff
    80004d5e:	830080e7          	jalr	-2000(ra) # 8000358a <begin_op>
  argint(1, &major);
    80004d62:	f6c40593          	addi	a1,s0,-148
    80004d66:	4505                	li	a0,1
    80004d68:	ffffd097          	auipc	ra,0xffffd
    80004d6c:	27c080e7          	jalr	636(ra) # 80001fe4 <argint>
  argint(2, &minor);
    80004d70:	f6840593          	addi	a1,s0,-152
    80004d74:	4509                	li	a0,2
    80004d76:	ffffd097          	auipc	ra,0xffffd
    80004d7a:	26e080e7          	jalr	622(ra) # 80001fe4 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d7e:	08000613          	li	a2,128
    80004d82:	f7040593          	addi	a1,s0,-144
    80004d86:	4501                	li	a0,0
    80004d88:	ffffd097          	auipc	ra,0xffffd
    80004d8c:	29c080e7          	jalr	668(ra) # 80002024 <argstr>
    80004d90:	02054b63          	bltz	a0,80004dc6 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d94:	f6841683          	lh	a3,-152(s0)
    80004d98:	f6c41603          	lh	a2,-148(s0)
    80004d9c:	458d                	li	a1,3
    80004d9e:	f7040513          	addi	a0,s0,-144
    80004da2:	fffff097          	auipc	ra,0xfffff
    80004da6:	77e080e7          	jalr	1918(ra) # 80004520 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004daa:	cd11                	beqz	a0,80004dc6 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dac:	ffffe097          	auipc	ra,0xffffe
    80004db0:	07e080e7          	jalr	126(ra) # 80002e2a <iunlockput>
  end_op();
    80004db4:	fffff097          	auipc	ra,0xfffff
    80004db8:	856080e7          	jalr	-1962(ra) # 8000360a <end_op>
  return 0;
    80004dbc:	4501                	li	a0,0
}
    80004dbe:	60ea                	ld	ra,152(sp)
    80004dc0:	644a                	ld	s0,144(sp)
    80004dc2:	610d                	addi	sp,sp,160
    80004dc4:	8082                	ret
    end_op();
    80004dc6:	fffff097          	auipc	ra,0xfffff
    80004dca:	844080e7          	jalr	-1980(ra) # 8000360a <end_op>
    return -1;
    80004dce:	557d                	li	a0,-1
    80004dd0:	b7fd                	j	80004dbe <sys_mknod+0x6c>

0000000080004dd2 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004dd2:	7135                	addi	sp,sp,-160
    80004dd4:	ed06                	sd	ra,152(sp)
    80004dd6:	e922                	sd	s0,144(sp)
    80004dd8:	e526                	sd	s1,136(sp)
    80004dda:	e14a                	sd	s2,128(sp)
    80004ddc:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004dde:	ffffc097          	auipc	ra,0xffffc
    80004de2:	07a080e7          	jalr	122(ra) # 80000e58 <myproc>
    80004de6:	892a                	mv	s2,a0
  
  begin_op();
    80004de8:	ffffe097          	auipc	ra,0xffffe
    80004dec:	7a2080e7          	jalr	1954(ra) # 8000358a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004df0:	08000613          	li	a2,128
    80004df4:	f6040593          	addi	a1,s0,-160
    80004df8:	4501                	li	a0,0
    80004dfa:	ffffd097          	auipc	ra,0xffffd
    80004dfe:	22a080e7          	jalr	554(ra) # 80002024 <argstr>
    80004e02:	04054b63          	bltz	a0,80004e58 <sys_chdir+0x86>
    80004e06:	f6040513          	addi	a0,s0,-160
    80004e0a:	ffffe097          	auipc	ra,0xffffe
    80004e0e:	564080e7          	jalr	1380(ra) # 8000336e <namei>
    80004e12:	84aa                	mv	s1,a0
    80004e14:	c131                	beqz	a0,80004e58 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e16:	ffffe097          	auipc	ra,0xffffe
    80004e1a:	db2080e7          	jalr	-590(ra) # 80002bc8 <ilock>
  if(ip->type != T_DIR){
    80004e1e:	04449703          	lh	a4,68(s1)
    80004e22:	4785                	li	a5,1
    80004e24:	04f71063          	bne	a4,a5,80004e64 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e28:	8526                	mv	a0,s1
    80004e2a:	ffffe097          	auipc	ra,0xffffe
    80004e2e:	e60080e7          	jalr	-416(ra) # 80002c8a <iunlock>
  iput(p->cwd);
    80004e32:	15093503          	ld	a0,336(s2)
    80004e36:	ffffe097          	auipc	ra,0xffffe
    80004e3a:	f4c080e7          	jalr	-180(ra) # 80002d82 <iput>
  end_op();
    80004e3e:	ffffe097          	auipc	ra,0xffffe
    80004e42:	7cc080e7          	jalr	1996(ra) # 8000360a <end_op>
  p->cwd = ip;
    80004e46:	14993823          	sd	s1,336(s2)
  return 0;
    80004e4a:	4501                	li	a0,0
}
    80004e4c:	60ea                	ld	ra,152(sp)
    80004e4e:	644a                	ld	s0,144(sp)
    80004e50:	64aa                	ld	s1,136(sp)
    80004e52:	690a                	ld	s2,128(sp)
    80004e54:	610d                	addi	sp,sp,160
    80004e56:	8082                	ret
    end_op();
    80004e58:	ffffe097          	auipc	ra,0xffffe
    80004e5c:	7b2080e7          	jalr	1970(ra) # 8000360a <end_op>
    return -1;
    80004e60:	557d                	li	a0,-1
    80004e62:	b7ed                	j	80004e4c <sys_chdir+0x7a>
    iunlockput(ip);
    80004e64:	8526                	mv	a0,s1
    80004e66:	ffffe097          	auipc	ra,0xffffe
    80004e6a:	fc4080e7          	jalr	-60(ra) # 80002e2a <iunlockput>
    end_op();
    80004e6e:	ffffe097          	auipc	ra,0xffffe
    80004e72:	79c080e7          	jalr	1948(ra) # 8000360a <end_op>
    return -1;
    80004e76:	557d                	li	a0,-1
    80004e78:	bfd1                	j	80004e4c <sys_chdir+0x7a>

0000000080004e7a <sys_exec>:

uint64
sys_exec(void)
{
    80004e7a:	7145                	addi	sp,sp,-464
    80004e7c:	e786                	sd	ra,456(sp)
    80004e7e:	e3a2                	sd	s0,448(sp)
    80004e80:	ff26                	sd	s1,440(sp)
    80004e82:	fb4a                	sd	s2,432(sp)
    80004e84:	f74e                	sd	s3,424(sp)
    80004e86:	f352                	sd	s4,416(sp)
    80004e88:	ef56                	sd	s5,408(sp)
    80004e8a:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004e8c:	e3840593          	addi	a1,s0,-456
    80004e90:	4505                	li	a0,1
    80004e92:	ffffd097          	auipc	ra,0xffffd
    80004e96:	172080e7          	jalr	370(ra) # 80002004 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004e9a:	08000613          	li	a2,128
    80004e9e:	f4040593          	addi	a1,s0,-192
    80004ea2:	4501                	li	a0,0
    80004ea4:	ffffd097          	auipc	ra,0xffffd
    80004ea8:	180080e7          	jalr	384(ra) # 80002024 <argstr>
    80004eac:	87aa                	mv	a5,a0
    return -1;
    80004eae:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004eb0:	0c07c263          	bltz	a5,80004f74 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004eb4:	10000613          	li	a2,256
    80004eb8:	4581                	li	a1,0
    80004eba:	e4040513          	addi	a0,s0,-448
    80004ebe:	ffffb097          	auipc	ra,0xffffb
    80004ec2:	2ba080e7          	jalr	698(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004ec6:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004eca:	89a6                	mv	s3,s1
    80004ecc:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004ece:	02000a13          	li	s4,32
    80004ed2:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004ed6:	00391513          	slli	a0,s2,0x3
    80004eda:	e3040593          	addi	a1,s0,-464
    80004ede:	e3843783          	ld	a5,-456(s0)
    80004ee2:	953e                	add	a0,a0,a5
    80004ee4:	ffffd097          	auipc	ra,0xffffd
    80004ee8:	062080e7          	jalr	98(ra) # 80001f46 <fetchaddr>
    80004eec:	02054a63          	bltz	a0,80004f20 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80004ef0:	e3043783          	ld	a5,-464(s0)
    80004ef4:	c3b9                	beqz	a5,80004f3a <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004ef6:	ffffb097          	auipc	ra,0xffffb
    80004efa:	222080e7          	jalr	546(ra) # 80000118 <kalloc>
    80004efe:	85aa                	mv	a1,a0
    80004f00:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f04:	cd11                	beqz	a0,80004f20 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f06:	6605                	lui	a2,0x1
    80004f08:	e3043503          	ld	a0,-464(s0)
    80004f0c:	ffffd097          	auipc	ra,0xffffd
    80004f10:	08c080e7          	jalr	140(ra) # 80001f98 <fetchstr>
    80004f14:	00054663          	bltz	a0,80004f20 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80004f18:	0905                	addi	s2,s2,1
    80004f1a:	09a1                	addi	s3,s3,8
    80004f1c:	fb491be3          	bne	s2,s4,80004ed2 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f20:	10048913          	addi	s2,s1,256
    80004f24:	6088                	ld	a0,0(s1)
    80004f26:	c531                	beqz	a0,80004f72 <sys_exec+0xf8>
    kfree(argv[i]);
    80004f28:	ffffb097          	auipc	ra,0xffffb
    80004f2c:	0f4080e7          	jalr	244(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f30:	04a1                	addi	s1,s1,8
    80004f32:	ff2499e3          	bne	s1,s2,80004f24 <sys_exec+0xaa>
  return -1;
    80004f36:	557d                	li	a0,-1
    80004f38:	a835                	j	80004f74 <sys_exec+0xfa>
      argv[i] = 0;
    80004f3a:	0a8e                	slli	s5,s5,0x3
    80004f3c:	fc040793          	addi	a5,s0,-64
    80004f40:	9abe                	add	s5,s5,a5
    80004f42:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f46:	e4040593          	addi	a1,s0,-448
    80004f4a:	f4040513          	addi	a0,s0,-192
    80004f4e:	fffff097          	auipc	ra,0xfffff
    80004f52:	190080e7          	jalr	400(ra) # 800040de <exec>
    80004f56:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f58:	10048993          	addi	s3,s1,256
    80004f5c:	6088                	ld	a0,0(s1)
    80004f5e:	c901                	beqz	a0,80004f6e <sys_exec+0xf4>
    kfree(argv[i]);
    80004f60:	ffffb097          	auipc	ra,0xffffb
    80004f64:	0bc080e7          	jalr	188(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f68:	04a1                	addi	s1,s1,8
    80004f6a:	ff3499e3          	bne	s1,s3,80004f5c <sys_exec+0xe2>
  return ret;
    80004f6e:	854a                	mv	a0,s2
    80004f70:	a011                	j	80004f74 <sys_exec+0xfa>
  return -1;
    80004f72:	557d                	li	a0,-1
}
    80004f74:	60be                	ld	ra,456(sp)
    80004f76:	641e                	ld	s0,448(sp)
    80004f78:	74fa                	ld	s1,440(sp)
    80004f7a:	795a                	ld	s2,432(sp)
    80004f7c:	79ba                	ld	s3,424(sp)
    80004f7e:	7a1a                	ld	s4,416(sp)
    80004f80:	6afa                	ld	s5,408(sp)
    80004f82:	6179                	addi	sp,sp,464
    80004f84:	8082                	ret

0000000080004f86 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f86:	7139                	addi	sp,sp,-64
    80004f88:	fc06                	sd	ra,56(sp)
    80004f8a:	f822                	sd	s0,48(sp)
    80004f8c:	f426                	sd	s1,40(sp)
    80004f8e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f90:	ffffc097          	auipc	ra,0xffffc
    80004f94:	ec8080e7          	jalr	-312(ra) # 80000e58 <myproc>
    80004f98:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004f9a:	fd840593          	addi	a1,s0,-40
    80004f9e:	4501                	li	a0,0
    80004fa0:	ffffd097          	auipc	ra,0xffffd
    80004fa4:	064080e7          	jalr	100(ra) # 80002004 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004fa8:	fc840593          	addi	a1,s0,-56
    80004fac:	fd040513          	addi	a0,s0,-48
    80004fb0:	fffff097          	auipc	ra,0xfffff
    80004fb4:	dd6080e7          	jalr	-554(ra) # 80003d86 <pipealloc>
    return -1;
    80004fb8:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004fba:	0c054463          	bltz	a0,80005082 <sys_pipe+0xfc>
  fd0 = -1;
    80004fbe:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004fc2:	fd043503          	ld	a0,-48(s0)
    80004fc6:	fffff097          	auipc	ra,0xfffff
    80004fca:	518080e7          	jalr	1304(ra) # 800044de <fdalloc>
    80004fce:	fca42223          	sw	a0,-60(s0)
    80004fd2:	08054b63          	bltz	a0,80005068 <sys_pipe+0xe2>
    80004fd6:	fc843503          	ld	a0,-56(s0)
    80004fda:	fffff097          	auipc	ra,0xfffff
    80004fde:	504080e7          	jalr	1284(ra) # 800044de <fdalloc>
    80004fe2:	fca42023          	sw	a0,-64(s0)
    80004fe6:	06054863          	bltz	a0,80005056 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fea:	4691                	li	a3,4
    80004fec:	fc440613          	addi	a2,s0,-60
    80004ff0:	fd843583          	ld	a1,-40(s0)
    80004ff4:	68a8                	ld	a0,80(s1)
    80004ff6:	ffffc097          	auipc	ra,0xffffc
    80004ffa:	b20080e7          	jalr	-1248(ra) # 80000b16 <copyout>
    80004ffe:	02054063          	bltz	a0,8000501e <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005002:	4691                	li	a3,4
    80005004:	fc040613          	addi	a2,s0,-64
    80005008:	fd843583          	ld	a1,-40(s0)
    8000500c:	0591                	addi	a1,a1,4
    8000500e:	68a8                	ld	a0,80(s1)
    80005010:	ffffc097          	auipc	ra,0xffffc
    80005014:	b06080e7          	jalr	-1274(ra) # 80000b16 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005018:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000501a:	06055463          	bgez	a0,80005082 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    8000501e:	fc442783          	lw	a5,-60(s0)
    80005022:	07e9                	addi	a5,a5,26
    80005024:	078e                	slli	a5,a5,0x3
    80005026:	97a6                	add	a5,a5,s1
    80005028:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000502c:	fc042503          	lw	a0,-64(s0)
    80005030:	0569                	addi	a0,a0,26
    80005032:	050e                	slli	a0,a0,0x3
    80005034:	94aa                	add	s1,s1,a0
    80005036:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000503a:	fd043503          	ld	a0,-48(s0)
    8000503e:	fffff097          	auipc	ra,0xfffff
    80005042:	a18080e7          	jalr	-1512(ra) # 80003a56 <fileclose>
    fileclose(wf);
    80005046:	fc843503          	ld	a0,-56(s0)
    8000504a:	fffff097          	auipc	ra,0xfffff
    8000504e:	a0c080e7          	jalr	-1524(ra) # 80003a56 <fileclose>
    return -1;
    80005052:	57fd                	li	a5,-1
    80005054:	a03d                	j	80005082 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005056:	fc442783          	lw	a5,-60(s0)
    8000505a:	0007c763          	bltz	a5,80005068 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    8000505e:	07e9                	addi	a5,a5,26
    80005060:	078e                	slli	a5,a5,0x3
    80005062:	94be                	add	s1,s1,a5
    80005064:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005068:	fd043503          	ld	a0,-48(s0)
    8000506c:	fffff097          	auipc	ra,0xfffff
    80005070:	9ea080e7          	jalr	-1558(ra) # 80003a56 <fileclose>
    fileclose(wf);
    80005074:	fc843503          	ld	a0,-56(s0)
    80005078:	fffff097          	auipc	ra,0xfffff
    8000507c:	9de080e7          	jalr	-1570(ra) # 80003a56 <fileclose>
    return -1;
    80005080:	57fd                	li	a5,-1
}
    80005082:	853e                	mv	a0,a5
    80005084:	70e2                	ld	ra,56(sp)
    80005086:	7442                	ld	s0,48(sp)
    80005088:	74a2                	ld	s1,40(sp)
    8000508a:	6121                	addi	sp,sp,64
    8000508c:	8082                	ret
	...

0000000080005090 <kernelvec>:
    80005090:	7111                	addi	sp,sp,-256
    80005092:	e006                	sd	ra,0(sp)
    80005094:	e40a                	sd	sp,8(sp)
    80005096:	e80e                	sd	gp,16(sp)
    80005098:	ec12                	sd	tp,24(sp)
    8000509a:	f016                	sd	t0,32(sp)
    8000509c:	f41a                	sd	t1,40(sp)
    8000509e:	f81e                	sd	t2,48(sp)
    800050a0:	fc22                	sd	s0,56(sp)
    800050a2:	e0a6                	sd	s1,64(sp)
    800050a4:	e4aa                	sd	a0,72(sp)
    800050a6:	e8ae                	sd	a1,80(sp)
    800050a8:	ecb2                	sd	a2,88(sp)
    800050aa:	f0b6                	sd	a3,96(sp)
    800050ac:	f4ba                	sd	a4,104(sp)
    800050ae:	f8be                	sd	a5,112(sp)
    800050b0:	fcc2                	sd	a6,120(sp)
    800050b2:	e146                	sd	a7,128(sp)
    800050b4:	e54a                	sd	s2,136(sp)
    800050b6:	e94e                	sd	s3,144(sp)
    800050b8:	ed52                	sd	s4,152(sp)
    800050ba:	f156                	sd	s5,160(sp)
    800050bc:	f55a                	sd	s6,168(sp)
    800050be:	f95e                	sd	s7,176(sp)
    800050c0:	fd62                	sd	s8,184(sp)
    800050c2:	e1e6                	sd	s9,192(sp)
    800050c4:	e5ea                	sd	s10,200(sp)
    800050c6:	e9ee                	sd	s11,208(sp)
    800050c8:	edf2                	sd	t3,216(sp)
    800050ca:	f1f6                	sd	t4,224(sp)
    800050cc:	f5fa                	sd	t5,232(sp)
    800050ce:	f9fe                	sd	t6,240(sp)
    800050d0:	d43fc0ef          	jal	ra,80001e12 <kerneltrap>
    800050d4:	6082                	ld	ra,0(sp)
    800050d6:	6122                	ld	sp,8(sp)
    800050d8:	61c2                	ld	gp,16(sp)
    800050da:	7282                	ld	t0,32(sp)
    800050dc:	7322                	ld	t1,40(sp)
    800050de:	73c2                	ld	t2,48(sp)
    800050e0:	7462                	ld	s0,56(sp)
    800050e2:	6486                	ld	s1,64(sp)
    800050e4:	6526                	ld	a0,72(sp)
    800050e6:	65c6                	ld	a1,80(sp)
    800050e8:	6666                	ld	a2,88(sp)
    800050ea:	7686                	ld	a3,96(sp)
    800050ec:	7726                	ld	a4,104(sp)
    800050ee:	77c6                	ld	a5,112(sp)
    800050f0:	7866                	ld	a6,120(sp)
    800050f2:	688a                	ld	a7,128(sp)
    800050f4:	692a                	ld	s2,136(sp)
    800050f6:	69ca                	ld	s3,144(sp)
    800050f8:	6a6a                	ld	s4,152(sp)
    800050fa:	7a8a                	ld	s5,160(sp)
    800050fc:	7b2a                	ld	s6,168(sp)
    800050fe:	7bca                	ld	s7,176(sp)
    80005100:	7c6a                	ld	s8,184(sp)
    80005102:	6c8e                	ld	s9,192(sp)
    80005104:	6d2e                	ld	s10,200(sp)
    80005106:	6dce                	ld	s11,208(sp)
    80005108:	6e6e                	ld	t3,216(sp)
    8000510a:	7e8e                	ld	t4,224(sp)
    8000510c:	7f2e                	ld	t5,232(sp)
    8000510e:	7fce                	ld	t6,240(sp)
    80005110:	6111                	addi	sp,sp,256
    80005112:	10200073          	sret
    80005116:	00000013          	nop
    8000511a:	00000013          	nop
    8000511e:	0001                	nop

0000000080005120 <timervec>:
    80005120:	34051573          	csrrw	a0,mscratch,a0
    80005124:	e10c                	sd	a1,0(a0)
    80005126:	e510                	sd	a2,8(a0)
    80005128:	e914                	sd	a3,16(a0)
    8000512a:	6d0c                	ld	a1,24(a0)
    8000512c:	7110                	ld	a2,32(a0)
    8000512e:	6194                	ld	a3,0(a1)
    80005130:	96b2                	add	a3,a3,a2
    80005132:	e194                	sd	a3,0(a1)
    80005134:	4589                	li	a1,2
    80005136:	14459073          	csrw	sip,a1
    8000513a:	6914                	ld	a3,16(a0)
    8000513c:	6510                	ld	a2,8(a0)
    8000513e:	610c                	ld	a1,0(a0)
    80005140:	34051573          	csrrw	a0,mscratch,a0
    80005144:	30200073          	mret
	...

000000008000514a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000514a:	1141                	addi	sp,sp,-16
    8000514c:	e422                	sd	s0,8(sp)
    8000514e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005150:	0c0007b7          	lui	a5,0xc000
    80005154:	4705                	li	a4,1
    80005156:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005158:	c3d8                	sw	a4,4(a5)
}
    8000515a:	6422                	ld	s0,8(sp)
    8000515c:	0141                	addi	sp,sp,16
    8000515e:	8082                	ret

0000000080005160 <plicinithart>:

void
plicinithart(void)
{
    80005160:	1141                	addi	sp,sp,-16
    80005162:	e406                	sd	ra,8(sp)
    80005164:	e022                	sd	s0,0(sp)
    80005166:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005168:	ffffc097          	auipc	ra,0xffffc
    8000516c:	cc4080e7          	jalr	-828(ra) # 80000e2c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005170:	0085171b          	slliw	a4,a0,0x8
    80005174:	0c0027b7          	lui	a5,0xc002
    80005178:	97ba                	add	a5,a5,a4
    8000517a:	40200713          	li	a4,1026
    8000517e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005182:	00d5151b          	slliw	a0,a0,0xd
    80005186:	0c2017b7          	lui	a5,0xc201
    8000518a:	953e                	add	a0,a0,a5
    8000518c:	00052023          	sw	zero,0(a0)
}
    80005190:	60a2                	ld	ra,8(sp)
    80005192:	6402                	ld	s0,0(sp)
    80005194:	0141                	addi	sp,sp,16
    80005196:	8082                	ret

0000000080005198 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005198:	1141                	addi	sp,sp,-16
    8000519a:	e406                	sd	ra,8(sp)
    8000519c:	e022                	sd	s0,0(sp)
    8000519e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051a0:	ffffc097          	auipc	ra,0xffffc
    800051a4:	c8c080e7          	jalr	-884(ra) # 80000e2c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051a8:	00d5179b          	slliw	a5,a0,0xd
    800051ac:	0c201537          	lui	a0,0xc201
    800051b0:	953e                	add	a0,a0,a5
  return irq;
}
    800051b2:	4148                	lw	a0,4(a0)
    800051b4:	60a2                	ld	ra,8(sp)
    800051b6:	6402                	ld	s0,0(sp)
    800051b8:	0141                	addi	sp,sp,16
    800051ba:	8082                	ret

00000000800051bc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051bc:	1101                	addi	sp,sp,-32
    800051be:	ec06                	sd	ra,24(sp)
    800051c0:	e822                	sd	s0,16(sp)
    800051c2:	e426                	sd	s1,8(sp)
    800051c4:	1000                	addi	s0,sp,32
    800051c6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051c8:	ffffc097          	auipc	ra,0xffffc
    800051cc:	c64080e7          	jalr	-924(ra) # 80000e2c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051d0:	00d5151b          	slliw	a0,a0,0xd
    800051d4:	0c2017b7          	lui	a5,0xc201
    800051d8:	97aa                	add	a5,a5,a0
    800051da:	c3c4                	sw	s1,4(a5)
}
    800051dc:	60e2                	ld	ra,24(sp)
    800051de:	6442                	ld	s0,16(sp)
    800051e0:	64a2                	ld	s1,8(sp)
    800051e2:	6105                	addi	sp,sp,32
    800051e4:	8082                	ret

00000000800051e6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051e6:	1141                	addi	sp,sp,-16
    800051e8:	e406                	sd	ra,8(sp)
    800051ea:	e022                	sd	s0,0(sp)
    800051ec:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800051ee:	479d                	li	a5,7
    800051f0:	04a7cc63          	blt	a5,a0,80005248 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800051f4:	00015797          	auipc	a5,0x15
    800051f8:	93c78793          	addi	a5,a5,-1732 # 80019b30 <disk>
    800051fc:	97aa                	add	a5,a5,a0
    800051fe:	0187c783          	lbu	a5,24(a5)
    80005202:	ebb9                	bnez	a5,80005258 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005204:	00451613          	slli	a2,a0,0x4
    80005208:	00015797          	auipc	a5,0x15
    8000520c:	92878793          	addi	a5,a5,-1752 # 80019b30 <disk>
    80005210:	6394                	ld	a3,0(a5)
    80005212:	96b2                	add	a3,a3,a2
    80005214:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005218:	6398                	ld	a4,0(a5)
    8000521a:	9732                	add	a4,a4,a2
    8000521c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005220:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005224:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005228:	953e                	add	a0,a0,a5
    8000522a:	4785                	li	a5,1
    8000522c:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80005230:	00015517          	auipc	a0,0x15
    80005234:	91850513          	addi	a0,a0,-1768 # 80019b48 <disk+0x18>
    80005238:	ffffc097          	auipc	ra,0xffffc
    8000523c:	3a4080e7          	jalr	932(ra) # 800015dc <wakeup>
}
    80005240:	60a2                	ld	ra,8(sp)
    80005242:	6402                	ld	s0,0(sp)
    80005244:	0141                	addi	sp,sp,16
    80005246:	8082                	ret
    panic("free_desc 1");
    80005248:	00003517          	auipc	a0,0x3
    8000524c:	5f050513          	addi	a0,a0,1520 # 80008838 <syscallnames+0x2f0>
    80005250:	00001097          	auipc	ra,0x1
    80005254:	a72080e7          	jalr	-1422(ra) # 80005cc2 <panic>
    panic("free_desc 2");
    80005258:	00003517          	auipc	a0,0x3
    8000525c:	5f050513          	addi	a0,a0,1520 # 80008848 <syscallnames+0x300>
    80005260:	00001097          	auipc	ra,0x1
    80005264:	a62080e7          	jalr	-1438(ra) # 80005cc2 <panic>

0000000080005268 <virtio_disk_init>:
{
    80005268:	1101                	addi	sp,sp,-32
    8000526a:	ec06                	sd	ra,24(sp)
    8000526c:	e822                	sd	s0,16(sp)
    8000526e:	e426                	sd	s1,8(sp)
    80005270:	e04a                	sd	s2,0(sp)
    80005272:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005274:	00003597          	auipc	a1,0x3
    80005278:	5e458593          	addi	a1,a1,1508 # 80008858 <syscallnames+0x310>
    8000527c:	00015517          	auipc	a0,0x15
    80005280:	9dc50513          	addi	a0,a0,-1572 # 80019c58 <disk+0x128>
    80005284:	00001097          	auipc	ra,0x1
    80005288:	ef8080e7          	jalr	-264(ra) # 8000617c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000528c:	100017b7          	lui	a5,0x10001
    80005290:	4398                	lw	a4,0(a5)
    80005292:	2701                	sext.w	a4,a4
    80005294:	747277b7          	lui	a5,0x74727
    80005298:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000529c:	14f71e63          	bne	a4,a5,800053f8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800052a0:	100017b7          	lui	a5,0x10001
    800052a4:	43dc                	lw	a5,4(a5)
    800052a6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052a8:	4709                	li	a4,2
    800052aa:	14e79763          	bne	a5,a4,800053f8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052ae:	100017b7          	lui	a5,0x10001
    800052b2:	479c                	lw	a5,8(a5)
    800052b4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800052b6:	14e79163          	bne	a5,a4,800053f8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052ba:	100017b7          	lui	a5,0x10001
    800052be:	47d8                	lw	a4,12(a5)
    800052c0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052c2:	554d47b7          	lui	a5,0x554d4
    800052c6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052ca:	12f71763          	bne	a4,a5,800053f8 <virtio_disk_init+0x190>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052ce:	100017b7          	lui	a5,0x10001
    800052d2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052d6:	4705                	li	a4,1
    800052d8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052da:	470d                	li	a4,3
    800052dc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800052de:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800052e0:	c7ffe737          	lui	a4,0xc7ffe
    800052e4:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc8af>
    800052e8:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800052ea:	2701                	sext.w	a4,a4
    800052ec:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052ee:	472d                	li	a4,11
    800052f0:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800052f2:	0707a903          	lw	s2,112(a5)
    800052f6:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800052f8:	00897793          	andi	a5,s2,8
    800052fc:	10078663          	beqz	a5,80005408 <virtio_disk_init+0x1a0>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005300:	100017b7          	lui	a5,0x10001
    80005304:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005308:	43fc                	lw	a5,68(a5)
    8000530a:	2781                	sext.w	a5,a5
    8000530c:	10079663          	bnez	a5,80005418 <virtio_disk_init+0x1b0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005310:	100017b7          	lui	a5,0x10001
    80005314:	5bdc                	lw	a5,52(a5)
    80005316:	2781                	sext.w	a5,a5
  if(max == 0)
    80005318:	10078863          	beqz	a5,80005428 <virtio_disk_init+0x1c0>
  if(max < NUM)
    8000531c:	471d                	li	a4,7
    8000531e:	10f77d63          	bgeu	a4,a5,80005438 <virtio_disk_init+0x1d0>
  disk.desc = kalloc();
    80005322:	ffffb097          	auipc	ra,0xffffb
    80005326:	df6080e7          	jalr	-522(ra) # 80000118 <kalloc>
    8000532a:	00015497          	auipc	s1,0x15
    8000532e:	80648493          	addi	s1,s1,-2042 # 80019b30 <disk>
    80005332:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005334:	ffffb097          	auipc	ra,0xffffb
    80005338:	de4080e7          	jalr	-540(ra) # 80000118 <kalloc>
    8000533c:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000533e:	ffffb097          	auipc	ra,0xffffb
    80005342:	dda080e7          	jalr	-550(ra) # 80000118 <kalloc>
    80005346:	87aa                	mv	a5,a0
    80005348:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    8000534a:	6088                	ld	a0,0(s1)
    8000534c:	cd75                	beqz	a0,80005448 <virtio_disk_init+0x1e0>
    8000534e:	00014717          	auipc	a4,0x14
    80005352:	7ea73703          	ld	a4,2026(a4) # 80019b38 <disk+0x8>
    80005356:	cb6d                	beqz	a4,80005448 <virtio_disk_init+0x1e0>
    80005358:	cbe5                	beqz	a5,80005448 <virtio_disk_init+0x1e0>
  memset(disk.desc, 0, PGSIZE);
    8000535a:	6605                	lui	a2,0x1
    8000535c:	4581                	li	a1,0
    8000535e:	ffffb097          	auipc	ra,0xffffb
    80005362:	e1a080e7          	jalr	-486(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005366:	00014497          	auipc	s1,0x14
    8000536a:	7ca48493          	addi	s1,s1,1994 # 80019b30 <disk>
    8000536e:	6605                	lui	a2,0x1
    80005370:	4581                	li	a1,0
    80005372:	6488                	ld	a0,8(s1)
    80005374:	ffffb097          	auipc	ra,0xffffb
    80005378:	e04080e7          	jalr	-508(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    8000537c:	6605                	lui	a2,0x1
    8000537e:	4581                	li	a1,0
    80005380:	6888                	ld	a0,16(s1)
    80005382:	ffffb097          	auipc	ra,0xffffb
    80005386:	df6080e7          	jalr	-522(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000538a:	100017b7          	lui	a5,0x10001
    8000538e:	4721                	li	a4,8
    80005390:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005392:	4098                	lw	a4,0(s1)
    80005394:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005398:	40d8                	lw	a4,4(s1)
    8000539a:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000539e:	6498                	ld	a4,8(s1)
    800053a0:	0007069b          	sext.w	a3,a4
    800053a4:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800053a8:	9701                	srai	a4,a4,0x20
    800053aa:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800053ae:	6898                	ld	a4,16(s1)
    800053b0:	0007069b          	sext.w	a3,a4
    800053b4:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800053b8:	9701                	srai	a4,a4,0x20
    800053ba:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800053be:	4685                	li	a3,1
    800053c0:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    800053c2:	4705                	li	a4,1
    800053c4:	00d48c23          	sb	a3,24(s1)
    800053c8:	00e48ca3          	sb	a4,25(s1)
    800053cc:	00e48d23          	sb	a4,26(s1)
    800053d0:	00e48da3          	sb	a4,27(s1)
    800053d4:	00e48e23          	sb	a4,28(s1)
    800053d8:	00e48ea3          	sb	a4,29(s1)
    800053dc:	00e48f23          	sb	a4,30(s1)
    800053e0:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800053e4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800053e8:	0727a823          	sw	s2,112(a5)
}
    800053ec:	60e2                	ld	ra,24(sp)
    800053ee:	6442                	ld	s0,16(sp)
    800053f0:	64a2                	ld	s1,8(sp)
    800053f2:	6902                	ld	s2,0(sp)
    800053f4:	6105                	addi	sp,sp,32
    800053f6:	8082                	ret
    panic("could not find virtio disk");
    800053f8:	00003517          	auipc	a0,0x3
    800053fc:	47050513          	addi	a0,a0,1136 # 80008868 <syscallnames+0x320>
    80005400:	00001097          	auipc	ra,0x1
    80005404:	8c2080e7          	jalr	-1854(ra) # 80005cc2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005408:	00003517          	auipc	a0,0x3
    8000540c:	48050513          	addi	a0,a0,1152 # 80008888 <syscallnames+0x340>
    80005410:	00001097          	auipc	ra,0x1
    80005414:	8b2080e7          	jalr	-1870(ra) # 80005cc2 <panic>
    panic("virtio disk should not be ready");
    80005418:	00003517          	auipc	a0,0x3
    8000541c:	49050513          	addi	a0,a0,1168 # 800088a8 <syscallnames+0x360>
    80005420:	00001097          	auipc	ra,0x1
    80005424:	8a2080e7          	jalr	-1886(ra) # 80005cc2 <panic>
    panic("virtio disk has no queue 0");
    80005428:	00003517          	auipc	a0,0x3
    8000542c:	4a050513          	addi	a0,a0,1184 # 800088c8 <syscallnames+0x380>
    80005430:	00001097          	auipc	ra,0x1
    80005434:	892080e7          	jalr	-1902(ra) # 80005cc2 <panic>
    panic("virtio disk max queue too short");
    80005438:	00003517          	auipc	a0,0x3
    8000543c:	4b050513          	addi	a0,a0,1200 # 800088e8 <syscallnames+0x3a0>
    80005440:	00001097          	auipc	ra,0x1
    80005444:	882080e7          	jalr	-1918(ra) # 80005cc2 <panic>
    panic("virtio disk kalloc");
    80005448:	00003517          	auipc	a0,0x3
    8000544c:	4c050513          	addi	a0,a0,1216 # 80008908 <syscallnames+0x3c0>
    80005450:	00001097          	auipc	ra,0x1
    80005454:	872080e7          	jalr	-1934(ra) # 80005cc2 <panic>

0000000080005458 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005458:	7159                	addi	sp,sp,-112
    8000545a:	f486                	sd	ra,104(sp)
    8000545c:	f0a2                	sd	s0,96(sp)
    8000545e:	eca6                	sd	s1,88(sp)
    80005460:	e8ca                	sd	s2,80(sp)
    80005462:	e4ce                	sd	s3,72(sp)
    80005464:	e0d2                	sd	s4,64(sp)
    80005466:	fc56                	sd	s5,56(sp)
    80005468:	f85a                	sd	s6,48(sp)
    8000546a:	f45e                	sd	s7,40(sp)
    8000546c:	f062                	sd	s8,32(sp)
    8000546e:	ec66                	sd	s9,24(sp)
    80005470:	e86a                	sd	s10,16(sp)
    80005472:	1880                	addi	s0,sp,112
    80005474:	892a                	mv	s2,a0
    80005476:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005478:	00c52c83          	lw	s9,12(a0)
    8000547c:	001c9c9b          	slliw	s9,s9,0x1
    80005480:	1c82                	slli	s9,s9,0x20
    80005482:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005486:	00014517          	auipc	a0,0x14
    8000548a:	7d250513          	addi	a0,a0,2002 # 80019c58 <disk+0x128>
    8000548e:	00001097          	auipc	ra,0x1
    80005492:	d7e080e7          	jalr	-642(ra) # 8000620c <acquire>
  for(int i = 0; i < 3; i++){
    80005496:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005498:	4ba1                	li	s7,8
      disk.free[i] = 0;
    8000549a:	00014b17          	auipc	s6,0x14
    8000549e:	696b0b13          	addi	s6,s6,1686 # 80019b30 <disk>
  for(int i = 0; i < 3; i++){
    800054a2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800054a4:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800054a6:	00014c17          	auipc	s8,0x14
    800054aa:	7b2c0c13          	addi	s8,s8,1970 # 80019c58 <disk+0x128>
    800054ae:	a8b5                	j	8000552a <virtio_disk_rw+0xd2>
      disk.free[i] = 0;
    800054b0:	00fb06b3          	add	a3,s6,a5
    800054b4:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800054b8:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800054ba:	0207c563          	bltz	a5,800054e4 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800054be:	2485                	addiw	s1,s1,1
    800054c0:	0711                	addi	a4,a4,4
    800054c2:	1f548a63          	beq	s1,s5,800056b6 <virtio_disk_rw+0x25e>
    idx[i] = alloc_desc();
    800054c6:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800054c8:	00014697          	auipc	a3,0x14
    800054cc:	66868693          	addi	a3,a3,1640 # 80019b30 <disk>
    800054d0:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800054d2:	0186c583          	lbu	a1,24(a3)
    800054d6:	fde9                	bnez	a1,800054b0 <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800054d8:	2785                	addiw	a5,a5,1
    800054da:	0685                	addi	a3,a3,1
    800054dc:	ff779be3          	bne	a5,s7,800054d2 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800054e0:	57fd                	li	a5,-1
    800054e2:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800054e4:	02905a63          	blez	s1,80005518 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800054e8:	f9042503          	lw	a0,-112(s0)
    800054ec:	00000097          	auipc	ra,0x0
    800054f0:	cfa080e7          	jalr	-774(ra) # 800051e6 <free_desc>
      for(int j = 0; j < i; j++)
    800054f4:	4785                	li	a5,1
    800054f6:	0297d163          	bge	a5,s1,80005518 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800054fa:	f9442503          	lw	a0,-108(s0)
    800054fe:	00000097          	auipc	ra,0x0
    80005502:	ce8080e7          	jalr	-792(ra) # 800051e6 <free_desc>
      for(int j = 0; j < i; j++)
    80005506:	4789                	li	a5,2
    80005508:	0097d863          	bge	a5,s1,80005518 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    8000550c:	f9842503          	lw	a0,-104(s0)
    80005510:	00000097          	auipc	ra,0x0
    80005514:	cd6080e7          	jalr	-810(ra) # 800051e6 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005518:	85e2                	mv	a1,s8
    8000551a:	00014517          	auipc	a0,0x14
    8000551e:	62e50513          	addi	a0,a0,1582 # 80019b48 <disk+0x18>
    80005522:	ffffc097          	auipc	ra,0xffffc
    80005526:	056080e7          	jalr	86(ra) # 80001578 <sleep>
  for(int i = 0; i < 3; i++){
    8000552a:	f9040713          	addi	a4,s0,-112
    8000552e:	84ce                	mv	s1,s3
    80005530:	bf59                	j	800054c6 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005532:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    80005536:	00479693          	slli	a3,a5,0x4
    8000553a:	00014797          	auipc	a5,0x14
    8000553e:	5f678793          	addi	a5,a5,1526 # 80019b30 <disk>
    80005542:	97b6                	add	a5,a5,a3
    80005544:	4685                	li	a3,1
    80005546:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005548:	00014597          	auipc	a1,0x14
    8000554c:	5e858593          	addi	a1,a1,1512 # 80019b30 <disk>
    80005550:	00a60793          	addi	a5,a2,10
    80005554:	0792                	slli	a5,a5,0x4
    80005556:	97ae                	add	a5,a5,a1
    80005558:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    8000555c:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005560:	f6070693          	addi	a3,a4,-160
    80005564:	619c                	ld	a5,0(a1)
    80005566:	97b6                	add	a5,a5,a3
    80005568:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000556a:	6188                	ld	a0,0(a1)
    8000556c:	96aa                	add	a3,a3,a0
    8000556e:	47c1                	li	a5,16
    80005570:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005572:	4785                	li	a5,1
    80005574:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005578:	f9442783          	lw	a5,-108(s0)
    8000557c:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005580:	0792                	slli	a5,a5,0x4
    80005582:	953e                	add	a0,a0,a5
    80005584:	05890693          	addi	a3,s2,88
    80005588:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000558a:	6188                	ld	a0,0(a1)
    8000558c:	97aa                	add	a5,a5,a0
    8000558e:	40000693          	li	a3,1024
    80005592:	c794                	sw	a3,8(a5)
  if(write)
    80005594:	100d0d63          	beqz	s10,800056ae <virtio_disk_rw+0x256>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005598:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000559c:	00c7d683          	lhu	a3,12(a5)
    800055a0:	0016e693          	ori	a3,a3,1
    800055a4:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    800055a8:	f9842583          	lw	a1,-104(s0)
    800055ac:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800055b0:	00014697          	auipc	a3,0x14
    800055b4:	58068693          	addi	a3,a3,1408 # 80019b30 <disk>
    800055b8:	00260793          	addi	a5,a2,2
    800055bc:	0792                	slli	a5,a5,0x4
    800055be:	97b6                	add	a5,a5,a3
    800055c0:	587d                	li	a6,-1
    800055c2:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800055c6:	0592                	slli	a1,a1,0x4
    800055c8:	952e                	add	a0,a0,a1
    800055ca:	f9070713          	addi	a4,a4,-112
    800055ce:	9736                	add	a4,a4,a3
    800055d0:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    800055d2:	6298                	ld	a4,0(a3)
    800055d4:	972e                	add	a4,a4,a1
    800055d6:	4585                	li	a1,1
    800055d8:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800055da:	4509                	li	a0,2
    800055dc:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    800055e0:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800055e4:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    800055e8:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800055ec:	6698                	ld	a4,8(a3)
    800055ee:	00275783          	lhu	a5,2(a4)
    800055f2:	8b9d                	andi	a5,a5,7
    800055f4:	0786                	slli	a5,a5,0x1
    800055f6:	97ba                	add	a5,a5,a4
    800055f8:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    800055fc:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005600:	6698                	ld	a4,8(a3)
    80005602:	00275783          	lhu	a5,2(a4)
    80005606:	2785                	addiw	a5,a5,1
    80005608:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000560c:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005610:	100017b7          	lui	a5,0x10001
    80005614:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005618:	00492703          	lw	a4,4(s2)
    8000561c:	4785                	li	a5,1
    8000561e:	02f71163          	bne	a4,a5,80005640 <virtio_disk_rw+0x1e8>
    sleep(b, &disk.vdisk_lock);
    80005622:	00014997          	auipc	s3,0x14
    80005626:	63698993          	addi	s3,s3,1590 # 80019c58 <disk+0x128>
  while(b->disk == 1) {
    8000562a:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000562c:	85ce                	mv	a1,s3
    8000562e:	854a                	mv	a0,s2
    80005630:	ffffc097          	auipc	ra,0xffffc
    80005634:	f48080e7          	jalr	-184(ra) # 80001578 <sleep>
  while(b->disk == 1) {
    80005638:	00492783          	lw	a5,4(s2)
    8000563c:	fe9788e3          	beq	a5,s1,8000562c <virtio_disk_rw+0x1d4>
  }

  disk.info[idx[0]].b = 0;
    80005640:	f9042903          	lw	s2,-112(s0)
    80005644:	00290793          	addi	a5,s2,2
    80005648:	00479713          	slli	a4,a5,0x4
    8000564c:	00014797          	auipc	a5,0x14
    80005650:	4e478793          	addi	a5,a5,1252 # 80019b30 <disk>
    80005654:	97ba                	add	a5,a5,a4
    80005656:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000565a:	00014997          	auipc	s3,0x14
    8000565e:	4d698993          	addi	s3,s3,1238 # 80019b30 <disk>
    80005662:	00491713          	slli	a4,s2,0x4
    80005666:	0009b783          	ld	a5,0(s3)
    8000566a:	97ba                	add	a5,a5,a4
    8000566c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005670:	854a                	mv	a0,s2
    80005672:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005676:	00000097          	auipc	ra,0x0
    8000567a:	b70080e7          	jalr	-1168(ra) # 800051e6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000567e:	8885                	andi	s1,s1,1
    80005680:	f0ed                	bnez	s1,80005662 <virtio_disk_rw+0x20a>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005682:	00014517          	auipc	a0,0x14
    80005686:	5d650513          	addi	a0,a0,1494 # 80019c58 <disk+0x128>
    8000568a:	00001097          	auipc	ra,0x1
    8000568e:	c36080e7          	jalr	-970(ra) # 800062c0 <release>
}
    80005692:	70a6                	ld	ra,104(sp)
    80005694:	7406                	ld	s0,96(sp)
    80005696:	64e6                	ld	s1,88(sp)
    80005698:	6946                	ld	s2,80(sp)
    8000569a:	69a6                	ld	s3,72(sp)
    8000569c:	6a06                	ld	s4,64(sp)
    8000569e:	7ae2                	ld	s5,56(sp)
    800056a0:	7b42                	ld	s6,48(sp)
    800056a2:	7ba2                	ld	s7,40(sp)
    800056a4:	7c02                	ld	s8,32(sp)
    800056a6:	6ce2                	ld	s9,24(sp)
    800056a8:	6d42                	ld	s10,16(sp)
    800056aa:	6165                	addi	sp,sp,112
    800056ac:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800056ae:	4689                	li	a3,2
    800056b0:	00d79623          	sh	a3,12(a5)
    800056b4:	b5e5                	j	8000559c <virtio_disk_rw+0x144>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056b6:	f9042603          	lw	a2,-112(s0)
    800056ba:	00a60713          	addi	a4,a2,10
    800056be:	0712                	slli	a4,a4,0x4
    800056c0:	00014517          	auipc	a0,0x14
    800056c4:	47850513          	addi	a0,a0,1144 # 80019b38 <disk+0x8>
    800056c8:	953a                	add	a0,a0,a4
  if(write)
    800056ca:	e60d14e3          	bnez	s10,80005532 <virtio_disk_rw+0xda>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800056ce:	00a60793          	addi	a5,a2,10
    800056d2:	00479693          	slli	a3,a5,0x4
    800056d6:	00014797          	auipc	a5,0x14
    800056da:	45a78793          	addi	a5,a5,1114 # 80019b30 <disk>
    800056de:	97b6                	add	a5,a5,a3
    800056e0:	0007a423          	sw	zero,8(a5)
    800056e4:	b595                	j	80005548 <virtio_disk_rw+0xf0>

00000000800056e6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800056e6:	1101                	addi	sp,sp,-32
    800056e8:	ec06                	sd	ra,24(sp)
    800056ea:	e822                	sd	s0,16(sp)
    800056ec:	e426                	sd	s1,8(sp)
    800056ee:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800056f0:	00014497          	auipc	s1,0x14
    800056f4:	44048493          	addi	s1,s1,1088 # 80019b30 <disk>
    800056f8:	00014517          	auipc	a0,0x14
    800056fc:	56050513          	addi	a0,a0,1376 # 80019c58 <disk+0x128>
    80005700:	00001097          	auipc	ra,0x1
    80005704:	b0c080e7          	jalr	-1268(ra) # 8000620c <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005708:	10001737          	lui	a4,0x10001
    8000570c:	533c                	lw	a5,96(a4)
    8000570e:	8b8d                	andi	a5,a5,3
    80005710:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005712:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005716:	689c                	ld	a5,16(s1)
    80005718:	0204d703          	lhu	a4,32(s1)
    8000571c:	0027d783          	lhu	a5,2(a5)
    80005720:	04f70863          	beq	a4,a5,80005770 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005724:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005728:	6898                	ld	a4,16(s1)
    8000572a:	0204d783          	lhu	a5,32(s1)
    8000572e:	8b9d                	andi	a5,a5,7
    80005730:	078e                	slli	a5,a5,0x3
    80005732:	97ba                	add	a5,a5,a4
    80005734:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005736:	00278713          	addi	a4,a5,2
    8000573a:	0712                	slli	a4,a4,0x4
    8000573c:	9726                	add	a4,a4,s1
    8000573e:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005742:	e721                	bnez	a4,8000578a <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005744:	0789                	addi	a5,a5,2
    80005746:	0792                	slli	a5,a5,0x4
    80005748:	97a6                	add	a5,a5,s1
    8000574a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000574c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005750:	ffffc097          	auipc	ra,0xffffc
    80005754:	e8c080e7          	jalr	-372(ra) # 800015dc <wakeup>

    disk.used_idx += 1;
    80005758:	0204d783          	lhu	a5,32(s1)
    8000575c:	2785                	addiw	a5,a5,1
    8000575e:	17c2                	slli	a5,a5,0x30
    80005760:	93c1                	srli	a5,a5,0x30
    80005762:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005766:	6898                	ld	a4,16(s1)
    80005768:	00275703          	lhu	a4,2(a4)
    8000576c:	faf71ce3          	bne	a4,a5,80005724 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005770:	00014517          	auipc	a0,0x14
    80005774:	4e850513          	addi	a0,a0,1256 # 80019c58 <disk+0x128>
    80005778:	00001097          	auipc	ra,0x1
    8000577c:	b48080e7          	jalr	-1208(ra) # 800062c0 <release>
}
    80005780:	60e2                	ld	ra,24(sp)
    80005782:	6442                	ld	s0,16(sp)
    80005784:	64a2                	ld	s1,8(sp)
    80005786:	6105                	addi	sp,sp,32
    80005788:	8082                	ret
      panic("virtio_disk_intr status");
    8000578a:	00003517          	auipc	a0,0x3
    8000578e:	19650513          	addi	a0,a0,406 # 80008920 <syscallnames+0x3d8>
    80005792:	00000097          	auipc	ra,0x0
    80005796:	530080e7          	jalr	1328(ra) # 80005cc2 <panic>

000000008000579a <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000579a:	1141                	addi	sp,sp,-16
    8000579c:	e422                	sd	s0,8(sp)
    8000579e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800057a0:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800057a4:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800057a8:	0037979b          	slliw	a5,a5,0x3
    800057ac:	02004737          	lui	a4,0x2004
    800057b0:	97ba                	add	a5,a5,a4
    800057b2:	0200c737          	lui	a4,0x200c
    800057b6:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800057ba:	000f4637          	lui	a2,0xf4
    800057be:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800057c2:	95b2                	add	a1,a1,a2
    800057c4:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800057c6:	00269713          	slli	a4,a3,0x2
    800057ca:	9736                	add	a4,a4,a3
    800057cc:	00371693          	slli	a3,a4,0x3
    800057d0:	00014717          	auipc	a4,0x14
    800057d4:	4a070713          	addi	a4,a4,1184 # 80019c70 <timer_scratch>
    800057d8:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800057da:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800057dc:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800057de:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800057e2:	00000797          	auipc	a5,0x0
    800057e6:	93e78793          	addi	a5,a5,-1730 # 80005120 <timervec>
    800057ea:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057ee:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800057f2:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057f6:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800057fa:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800057fe:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005802:	30479073          	csrw	mie,a5
}
    80005806:	6422                	ld	s0,8(sp)
    80005808:	0141                	addi	sp,sp,16
    8000580a:	8082                	ret

000000008000580c <start>:
{
    8000580c:	1141                	addi	sp,sp,-16
    8000580e:	e406                	sd	ra,8(sp)
    80005810:	e022                	sd	s0,0(sp)
    80005812:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005814:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005818:	7779                	lui	a4,0xffffe
    8000581a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc94f>
    8000581e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005820:	6705                	lui	a4,0x1
    80005822:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005826:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005828:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000582c:	ffffb797          	auipc	a5,0xffffb
    80005830:	afa78793          	addi	a5,a5,-1286 # 80000326 <main>
    80005834:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005838:	4781                	li	a5,0
    8000583a:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000583e:	67c1                	lui	a5,0x10
    80005840:	17fd                	addi	a5,a5,-1
    80005842:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005846:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000584a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000584e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005852:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005856:	57fd                	li	a5,-1
    80005858:	83a9                	srli	a5,a5,0xa
    8000585a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000585e:	47bd                	li	a5,15
    80005860:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005864:	00000097          	auipc	ra,0x0
    80005868:	f36080e7          	jalr	-202(ra) # 8000579a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000586c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005870:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005872:	823e                	mv	tp,a5
  asm volatile("mret");
    80005874:	30200073          	mret
}
    80005878:	60a2                	ld	ra,8(sp)
    8000587a:	6402                	ld	s0,0(sp)
    8000587c:	0141                	addi	sp,sp,16
    8000587e:	8082                	ret

0000000080005880 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005880:	715d                	addi	sp,sp,-80
    80005882:	e486                	sd	ra,72(sp)
    80005884:	e0a2                	sd	s0,64(sp)
    80005886:	fc26                	sd	s1,56(sp)
    80005888:	f84a                	sd	s2,48(sp)
    8000588a:	f44e                	sd	s3,40(sp)
    8000588c:	f052                	sd	s4,32(sp)
    8000588e:	ec56                	sd	s5,24(sp)
    80005890:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005892:	04c05663          	blez	a2,800058de <consolewrite+0x5e>
    80005896:	8a2a                	mv	s4,a0
    80005898:	84ae                	mv	s1,a1
    8000589a:	89b2                	mv	s3,a2
    8000589c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000589e:	5afd                	li	s5,-1
    800058a0:	4685                	li	a3,1
    800058a2:	8626                	mv	a2,s1
    800058a4:	85d2                	mv	a1,s4
    800058a6:	fbf40513          	addi	a0,s0,-65
    800058aa:	ffffc097          	auipc	ra,0xffffc
    800058ae:	12c080e7          	jalr	300(ra) # 800019d6 <either_copyin>
    800058b2:	01550c63          	beq	a0,s5,800058ca <consolewrite+0x4a>
      break;
    uartputc(c);
    800058b6:	fbf44503          	lbu	a0,-65(s0)
    800058ba:	00000097          	auipc	ra,0x0
    800058be:	794080e7          	jalr	1940(ra) # 8000604e <uartputc>
  for(i = 0; i < n; i++){
    800058c2:	2905                	addiw	s2,s2,1
    800058c4:	0485                	addi	s1,s1,1
    800058c6:	fd299de3          	bne	s3,s2,800058a0 <consolewrite+0x20>
  }

  return i;
}
    800058ca:	854a                	mv	a0,s2
    800058cc:	60a6                	ld	ra,72(sp)
    800058ce:	6406                	ld	s0,64(sp)
    800058d0:	74e2                	ld	s1,56(sp)
    800058d2:	7942                	ld	s2,48(sp)
    800058d4:	79a2                	ld	s3,40(sp)
    800058d6:	7a02                	ld	s4,32(sp)
    800058d8:	6ae2                	ld	s5,24(sp)
    800058da:	6161                	addi	sp,sp,80
    800058dc:	8082                	ret
  for(i = 0; i < n; i++){
    800058de:	4901                	li	s2,0
    800058e0:	b7ed                	j	800058ca <consolewrite+0x4a>

00000000800058e2 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800058e2:	7119                	addi	sp,sp,-128
    800058e4:	fc86                	sd	ra,120(sp)
    800058e6:	f8a2                	sd	s0,112(sp)
    800058e8:	f4a6                	sd	s1,104(sp)
    800058ea:	f0ca                	sd	s2,96(sp)
    800058ec:	ecce                	sd	s3,88(sp)
    800058ee:	e8d2                	sd	s4,80(sp)
    800058f0:	e4d6                	sd	s5,72(sp)
    800058f2:	e0da                	sd	s6,64(sp)
    800058f4:	fc5e                	sd	s7,56(sp)
    800058f6:	f862                	sd	s8,48(sp)
    800058f8:	f466                	sd	s9,40(sp)
    800058fa:	f06a                	sd	s10,32(sp)
    800058fc:	ec6e                	sd	s11,24(sp)
    800058fe:	0100                	addi	s0,sp,128
    80005900:	8b2a                	mv	s6,a0
    80005902:	8aae                	mv	s5,a1
    80005904:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005906:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    8000590a:	0001c517          	auipc	a0,0x1c
    8000590e:	4a650513          	addi	a0,a0,1190 # 80021db0 <cons>
    80005912:	00001097          	auipc	ra,0x1
    80005916:	8fa080e7          	jalr	-1798(ra) # 8000620c <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000591a:	0001c497          	auipc	s1,0x1c
    8000591e:	49648493          	addi	s1,s1,1174 # 80021db0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005922:	89a6                	mv	s3,s1
    80005924:	0001c917          	auipc	s2,0x1c
    80005928:	52490913          	addi	s2,s2,1316 # 80021e48 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    8000592c:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000592e:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005930:	4da9                	li	s11,10
  while(n > 0){
    80005932:	07405b63          	blez	s4,800059a8 <consoleread+0xc6>
    while(cons.r == cons.w){
    80005936:	0984a783          	lw	a5,152(s1)
    8000593a:	09c4a703          	lw	a4,156(s1)
    8000593e:	02f71763          	bne	a4,a5,8000596c <consoleread+0x8a>
      if(killed(myproc())){
    80005942:	ffffb097          	auipc	ra,0xffffb
    80005946:	516080e7          	jalr	1302(ra) # 80000e58 <myproc>
    8000594a:	ffffc097          	auipc	ra,0xffffc
    8000594e:	ed6080e7          	jalr	-298(ra) # 80001820 <killed>
    80005952:	e535                	bnez	a0,800059be <consoleread+0xdc>
      sleep(&cons.r, &cons.lock);
    80005954:	85ce                	mv	a1,s3
    80005956:	854a                	mv	a0,s2
    80005958:	ffffc097          	auipc	ra,0xffffc
    8000595c:	c20080e7          	jalr	-992(ra) # 80001578 <sleep>
    while(cons.r == cons.w){
    80005960:	0984a783          	lw	a5,152(s1)
    80005964:	09c4a703          	lw	a4,156(s1)
    80005968:	fcf70de3          	beq	a4,a5,80005942 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    8000596c:	0017871b          	addiw	a4,a5,1
    80005970:	08e4ac23          	sw	a4,152(s1)
    80005974:	07f7f713          	andi	a4,a5,127
    80005978:	9726                	add	a4,a4,s1
    8000597a:	01874703          	lbu	a4,24(a4)
    8000597e:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005982:	079c0663          	beq	s8,s9,800059ee <consoleread+0x10c>
    cbuf = c;
    80005986:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000598a:	4685                	li	a3,1
    8000598c:	f8f40613          	addi	a2,s0,-113
    80005990:	85d6                	mv	a1,s5
    80005992:	855a                	mv	a0,s6
    80005994:	ffffc097          	auipc	ra,0xffffc
    80005998:	fec080e7          	jalr	-20(ra) # 80001980 <either_copyout>
    8000599c:	01a50663          	beq	a0,s10,800059a8 <consoleread+0xc6>
    dst++;
    800059a0:	0a85                	addi	s5,s5,1
    --n;
    800059a2:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    800059a4:	f9bc17e3          	bne	s8,s11,80005932 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800059a8:	0001c517          	auipc	a0,0x1c
    800059ac:	40850513          	addi	a0,a0,1032 # 80021db0 <cons>
    800059b0:	00001097          	auipc	ra,0x1
    800059b4:	910080e7          	jalr	-1776(ra) # 800062c0 <release>

  return target - n;
    800059b8:	414b853b          	subw	a0,s7,s4
    800059bc:	a811                	j	800059d0 <consoleread+0xee>
        release(&cons.lock);
    800059be:	0001c517          	auipc	a0,0x1c
    800059c2:	3f250513          	addi	a0,a0,1010 # 80021db0 <cons>
    800059c6:	00001097          	auipc	ra,0x1
    800059ca:	8fa080e7          	jalr	-1798(ra) # 800062c0 <release>
        return -1;
    800059ce:	557d                	li	a0,-1
}
    800059d0:	70e6                	ld	ra,120(sp)
    800059d2:	7446                	ld	s0,112(sp)
    800059d4:	74a6                	ld	s1,104(sp)
    800059d6:	7906                	ld	s2,96(sp)
    800059d8:	69e6                	ld	s3,88(sp)
    800059da:	6a46                	ld	s4,80(sp)
    800059dc:	6aa6                	ld	s5,72(sp)
    800059de:	6b06                	ld	s6,64(sp)
    800059e0:	7be2                	ld	s7,56(sp)
    800059e2:	7c42                	ld	s8,48(sp)
    800059e4:	7ca2                	ld	s9,40(sp)
    800059e6:	7d02                	ld	s10,32(sp)
    800059e8:	6de2                	ld	s11,24(sp)
    800059ea:	6109                	addi	sp,sp,128
    800059ec:	8082                	ret
      if(n < target){
    800059ee:	000a071b          	sext.w	a4,s4
    800059f2:	fb777be3          	bgeu	a4,s7,800059a8 <consoleread+0xc6>
        cons.r--;
    800059f6:	0001c717          	auipc	a4,0x1c
    800059fa:	44f72923          	sw	a5,1106(a4) # 80021e48 <cons+0x98>
    800059fe:	b76d                	j	800059a8 <consoleread+0xc6>

0000000080005a00 <consputc>:
{
    80005a00:	1141                	addi	sp,sp,-16
    80005a02:	e406                	sd	ra,8(sp)
    80005a04:	e022                	sd	s0,0(sp)
    80005a06:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005a08:	10000793          	li	a5,256
    80005a0c:	00f50a63          	beq	a0,a5,80005a20 <consputc+0x20>
    uartputc_sync(c);
    80005a10:	00000097          	auipc	ra,0x0
    80005a14:	564080e7          	jalr	1380(ra) # 80005f74 <uartputc_sync>
}
    80005a18:	60a2                	ld	ra,8(sp)
    80005a1a:	6402                	ld	s0,0(sp)
    80005a1c:	0141                	addi	sp,sp,16
    80005a1e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005a20:	4521                	li	a0,8
    80005a22:	00000097          	auipc	ra,0x0
    80005a26:	552080e7          	jalr	1362(ra) # 80005f74 <uartputc_sync>
    80005a2a:	02000513          	li	a0,32
    80005a2e:	00000097          	auipc	ra,0x0
    80005a32:	546080e7          	jalr	1350(ra) # 80005f74 <uartputc_sync>
    80005a36:	4521                	li	a0,8
    80005a38:	00000097          	auipc	ra,0x0
    80005a3c:	53c080e7          	jalr	1340(ra) # 80005f74 <uartputc_sync>
    80005a40:	bfe1                	j	80005a18 <consputc+0x18>

0000000080005a42 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005a42:	1101                	addi	sp,sp,-32
    80005a44:	ec06                	sd	ra,24(sp)
    80005a46:	e822                	sd	s0,16(sp)
    80005a48:	e426                	sd	s1,8(sp)
    80005a4a:	e04a                	sd	s2,0(sp)
    80005a4c:	1000                	addi	s0,sp,32
    80005a4e:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005a50:	0001c517          	auipc	a0,0x1c
    80005a54:	36050513          	addi	a0,a0,864 # 80021db0 <cons>
    80005a58:	00000097          	auipc	ra,0x0
    80005a5c:	7b4080e7          	jalr	1972(ra) # 8000620c <acquire>

  switch(c){
    80005a60:	47d5                	li	a5,21
    80005a62:	0af48663          	beq	s1,a5,80005b0e <consoleintr+0xcc>
    80005a66:	0297ca63          	blt	a5,s1,80005a9a <consoleintr+0x58>
    80005a6a:	47a1                	li	a5,8
    80005a6c:	0ef48763          	beq	s1,a5,80005b5a <consoleintr+0x118>
    80005a70:	47c1                	li	a5,16
    80005a72:	10f49a63          	bne	s1,a5,80005b86 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005a76:	ffffc097          	auipc	ra,0xffffc
    80005a7a:	fb6080e7          	jalr	-74(ra) # 80001a2c <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a7e:	0001c517          	auipc	a0,0x1c
    80005a82:	33250513          	addi	a0,a0,818 # 80021db0 <cons>
    80005a86:	00001097          	auipc	ra,0x1
    80005a8a:	83a080e7          	jalr	-1990(ra) # 800062c0 <release>
}
    80005a8e:	60e2                	ld	ra,24(sp)
    80005a90:	6442                	ld	s0,16(sp)
    80005a92:	64a2                	ld	s1,8(sp)
    80005a94:	6902                	ld	s2,0(sp)
    80005a96:	6105                	addi	sp,sp,32
    80005a98:	8082                	ret
  switch(c){
    80005a9a:	07f00793          	li	a5,127
    80005a9e:	0af48e63          	beq	s1,a5,80005b5a <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005aa2:	0001c717          	auipc	a4,0x1c
    80005aa6:	30e70713          	addi	a4,a4,782 # 80021db0 <cons>
    80005aaa:	0a072783          	lw	a5,160(a4)
    80005aae:	09872703          	lw	a4,152(a4)
    80005ab2:	9f99                	subw	a5,a5,a4
    80005ab4:	07f00713          	li	a4,127
    80005ab8:	fcf763e3          	bltu	a4,a5,80005a7e <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005abc:	47b5                	li	a5,13
    80005abe:	0cf48763          	beq	s1,a5,80005b8c <consoleintr+0x14a>
      consputc(c);
    80005ac2:	8526                	mv	a0,s1
    80005ac4:	00000097          	auipc	ra,0x0
    80005ac8:	f3c080e7          	jalr	-196(ra) # 80005a00 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005acc:	0001c797          	auipc	a5,0x1c
    80005ad0:	2e478793          	addi	a5,a5,740 # 80021db0 <cons>
    80005ad4:	0a07a683          	lw	a3,160(a5)
    80005ad8:	0016871b          	addiw	a4,a3,1
    80005adc:	0007061b          	sext.w	a2,a4
    80005ae0:	0ae7a023          	sw	a4,160(a5)
    80005ae4:	07f6f693          	andi	a3,a3,127
    80005ae8:	97b6                	add	a5,a5,a3
    80005aea:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005aee:	47a9                	li	a5,10
    80005af0:	0cf48563          	beq	s1,a5,80005bba <consoleintr+0x178>
    80005af4:	4791                	li	a5,4
    80005af6:	0cf48263          	beq	s1,a5,80005bba <consoleintr+0x178>
    80005afa:	0001c797          	auipc	a5,0x1c
    80005afe:	34e7a783          	lw	a5,846(a5) # 80021e48 <cons+0x98>
    80005b02:	9f1d                	subw	a4,a4,a5
    80005b04:	08000793          	li	a5,128
    80005b08:	f6f71be3          	bne	a4,a5,80005a7e <consoleintr+0x3c>
    80005b0c:	a07d                	j	80005bba <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005b0e:	0001c717          	auipc	a4,0x1c
    80005b12:	2a270713          	addi	a4,a4,674 # 80021db0 <cons>
    80005b16:	0a072783          	lw	a5,160(a4)
    80005b1a:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005b1e:	0001c497          	auipc	s1,0x1c
    80005b22:	29248493          	addi	s1,s1,658 # 80021db0 <cons>
    while(cons.e != cons.w &&
    80005b26:	4929                	li	s2,10
    80005b28:	f4f70be3          	beq	a4,a5,80005a7e <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005b2c:	37fd                	addiw	a5,a5,-1
    80005b2e:	07f7f713          	andi	a4,a5,127
    80005b32:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005b34:	01874703          	lbu	a4,24(a4)
    80005b38:	f52703e3          	beq	a4,s2,80005a7e <consoleintr+0x3c>
      cons.e--;
    80005b3c:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005b40:	10000513          	li	a0,256
    80005b44:	00000097          	auipc	ra,0x0
    80005b48:	ebc080e7          	jalr	-324(ra) # 80005a00 <consputc>
    while(cons.e != cons.w &&
    80005b4c:	0a04a783          	lw	a5,160(s1)
    80005b50:	09c4a703          	lw	a4,156(s1)
    80005b54:	fcf71ce3          	bne	a4,a5,80005b2c <consoleintr+0xea>
    80005b58:	b71d                	j	80005a7e <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005b5a:	0001c717          	auipc	a4,0x1c
    80005b5e:	25670713          	addi	a4,a4,598 # 80021db0 <cons>
    80005b62:	0a072783          	lw	a5,160(a4)
    80005b66:	09c72703          	lw	a4,156(a4)
    80005b6a:	f0f70ae3          	beq	a4,a5,80005a7e <consoleintr+0x3c>
      cons.e--;
    80005b6e:	37fd                	addiw	a5,a5,-1
    80005b70:	0001c717          	auipc	a4,0x1c
    80005b74:	2ef72023          	sw	a5,736(a4) # 80021e50 <cons+0xa0>
      consputc(BACKSPACE);
    80005b78:	10000513          	li	a0,256
    80005b7c:	00000097          	auipc	ra,0x0
    80005b80:	e84080e7          	jalr	-380(ra) # 80005a00 <consputc>
    80005b84:	bded                	j	80005a7e <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005b86:	ee048ce3          	beqz	s1,80005a7e <consoleintr+0x3c>
    80005b8a:	bf21                	j	80005aa2 <consoleintr+0x60>
      consputc(c);
    80005b8c:	4529                	li	a0,10
    80005b8e:	00000097          	auipc	ra,0x0
    80005b92:	e72080e7          	jalr	-398(ra) # 80005a00 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005b96:	0001c797          	auipc	a5,0x1c
    80005b9a:	21a78793          	addi	a5,a5,538 # 80021db0 <cons>
    80005b9e:	0a07a703          	lw	a4,160(a5)
    80005ba2:	0017069b          	addiw	a3,a4,1
    80005ba6:	0006861b          	sext.w	a2,a3
    80005baa:	0ad7a023          	sw	a3,160(a5)
    80005bae:	07f77713          	andi	a4,a4,127
    80005bb2:	97ba                	add	a5,a5,a4
    80005bb4:	4729                	li	a4,10
    80005bb6:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005bba:	0001c797          	auipc	a5,0x1c
    80005bbe:	28c7a923          	sw	a2,658(a5) # 80021e4c <cons+0x9c>
        wakeup(&cons.r);
    80005bc2:	0001c517          	auipc	a0,0x1c
    80005bc6:	28650513          	addi	a0,a0,646 # 80021e48 <cons+0x98>
    80005bca:	ffffc097          	auipc	ra,0xffffc
    80005bce:	a12080e7          	jalr	-1518(ra) # 800015dc <wakeup>
    80005bd2:	b575                	j	80005a7e <consoleintr+0x3c>

0000000080005bd4 <consoleinit>:

void
consoleinit(void)
{
    80005bd4:	1141                	addi	sp,sp,-16
    80005bd6:	e406                	sd	ra,8(sp)
    80005bd8:	e022                	sd	s0,0(sp)
    80005bda:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005bdc:	00003597          	auipc	a1,0x3
    80005be0:	d5c58593          	addi	a1,a1,-676 # 80008938 <syscallnames+0x3f0>
    80005be4:	0001c517          	auipc	a0,0x1c
    80005be8:	1cc50513          	addi	a0,a0,460 # 80021db0 <cons>
    80005bec:	00000097          	auipc	ra,0x0
    80005bf0:	590080e7          	jalr	1424(ra) # 8000617c <initlock>

  uartinit();
    80005bf4:	00000097          	auipc	ra,0x0
    80005bf8:	330080e7          	jalr	816(ra) # 80005f24 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005bfc:	00013797          	auipc	a5,0x13
    80005c00:	edc78793          	addi	a5,a5,-292 # 80018ad8 <devsw>
    80005c04:	00000717          	auipc	a4,0x0
    80005c08:	cde70713          	addi	a4,a4,-802 # 800058e2 <consoleread>
    80005c0c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005c0e:	00000717          	auipc	a4,0x0
    80005c12:	c7270713          	addi	a4,a4,-910 # 80005880 <consolewrite>
    80005c16:	ef98                	sd	a4,24(a5)
}
    80005c18:	60a2                	ld	ra,8(sp)
    80005c1a:	6402                	ld	s0,0(sp)
    80005c1c:	0141                	addi	sp,sp,16
    80005c1e:	8082                	ret

0000000080005c20 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005c20:	7179                	addi	sp,sp,-48
    80005c22:	f406                	sd	ra,40(sp)
    80005c24:	f022                	sd	s0,32(sp)
    80005c26:	ec26                	sd	s1,24(sp)
    80005c28:	e84a                	sd	s2,16(sp)
    80005c2a:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005c2c:	c219                	beqz	a2,80005c32 <printint+0x12>
    80005c2e:	08054663          	bltz	a0,80005cba <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005c32:	2501                	sext.w	a0,a0
    80005c34:	4881                	li	a7,0
    80005c36:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005c3a:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005c3c:	2581                	sext.w	a1,a1
    80005c3e:	00003617          	auipc	a2,0x3
    80005c42:	d2a60613          	addi	a2,a2,-726 # 80008968 <digits>
    80005c46:	883a                	mv	a6,a4
    80005c48:	2705                	addiw	a4,a4,1
    80005c4a:	02b577bb          	remuw	a5,a0,a1
    80005c4e:	1782                	slli	a5,a5,0x20
    80005c50:	9381                	srli	a5,a5,0x20
    80005c52:	97b2                	add	a5,a5,a2
    80005c54:	0007c783          	lbu	a5,0(a5)
    80005c58:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005c5c:	0005079b          	sext.w	a5,a0
    80005c60:	02b5553b          	divuw	a0,a0,a1
    80005c64:	0685                	addi	a3,a3,1
    80005c66:	feb7f0e3          	bgeu	a5,a1,80005c46 <printint+0x26>

  if(sign)
    80005c6a:	00088b63          	beqz	a7,80005c80 <printint+0x60>
    buf[i++] = '-';
    80005c6e:	fe040793          	addi	a5,s0,-32
    80005c72:	973e                	add	a4,a4,a5
    80005c74:	02d00793          	li	a5,45
    80005c78:	fef70823          	sb	a5,-16(a4)
    80005c7c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005c80:	02e05763          	blez	a4,80005cae <printint+0x8e>
    80005c84:	fd040793          	addi	a5,s0,-48
    80005c88:	00e784b3          	add	s1,a5,a4
    80005c8c:	fff78913          	addi	s2,a5,-1
    80005c90:	993a                	add	s2,s2,a4
    80005c92:	377d                	addiw	a4,a4,-1
    80005c94:	1702                	slli	a4,a4,0x20
    80005c96:	9301                	srli	a4,a4,0x20
    80005c98:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c9c:	fff4c503          	lbu	a0,-1(s1)
    80005ca0:	00000097          	auipc	ra,0x0
    80005ca4:	d60080e7          	jalr	-672(ra) # 80005a00 <consputc>
  while(--i >= 0)
    80005ca8:	14fd                	addi	s1,s1,-1
    80005caa:	ff2499e3          	bne	s1,s2,80005c9c <printint+0x7c>
}
    80005cae:	70a2                	ld	ra,40(sp)
    80005cb0:	7402                	ld	s0,32(sp)
    80005cb2:	64e2                	ld	s1,24(sp)
    80005cb4:	6942                	ld	s2,16(sp)
    80005cb6:	6145                	addi	sp,sp,48
    80005cb8:	8082                	ret
    x = -xx;
    80005cba:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005cbe:	4885                	li	a7,1
    x = -xx;
    80005cc0:	bf9d                	j	80005c36 <printint+0x16>

0000000080005cc2 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005cc2:	1101                	addi	sp,sp,-32
    80005cc4:	ec06                	sd	ra,24(sp)
    80005cc6:	e822                	sd	s0,16(sp)
    80005cc8:	e426                	sd	s1,8(sp)
    80005cca:	1000                	addi	s0,sp,32
    80005ccc:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005cce:	0001c797          	auipc	a5,0x1c
    80005cd2:	1a07a123          	sw	zero,418(a5) # 80021e70 <pr+0x18>
  printf("panic: ");
    80005cd6:	00003517          	auipc	a0,0x3
    80005cda:	c6a50513          	addi	a0,a0,-918 # 80008940 <syscallnames+0x3f8>
    80005cde:	00000097          	auipc	ra,0x0
    80005ce2:	02e080e7          	jalr	46(ra) # 80005d0c <printf>
  printf(s);
    80005ce6:	8526                	mv	a0,s1
    80005ce8:	00000097          	auipc	ra,0x0
    80005cec:	024080e7          	jalr	36(ra) # 80005d0c <printf>
  printf("\n");
    80005cf0:	00002517          	auipc	a0,0x2
    80005cf4:	35850513          	addi	a0,a0,856 # 80008048 <etext+0x48>
    80005cf8:	00000097          	auipc	ra,0x0
    80005cfc:	014080e7          	jalr	20(ra) # 80005d0c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005d00:	4785                	li	a5,1
    80005d02:	00003717          	auipc	a4,0x3
    80005d06:	d2f72523          	sw	a5,-726(a4) # 80008a2c <panicked>
  for(;;)
    80005d0a:	a001                	j	80005d0a <panic+0x48>

0000000080005d0c <printf>:
{
    80005d0c:	7131                	addi	sp,sp,-192
    80005d0e:	fc86                	sd	ra,120(sp)
    80005d10:	f8a2                	sd	s0,112(sp)
    80005d12:	f4a6                	sd	s1,104(sp)
    80005d14:	f0ca                	sd	s2,96(sp)
    80005d16:	ecce                	sd	s3,88(sp)
    80005d18:	e8d2                	sd	s4,80(sp)
    80005d1a:	e4d6                	sd	s5,72(sp)
    80005d1c:	e0da                	sd	s6,64(sp)
    80005d1e:	fc5e                	sd	s7,56(sp)
    80005d20:	f862                	sd	s8,48(sp)
    80005d22:	f466                	sd	s9,40(sp)
    80005d24:	f06a                	sd	s10,32(sp)
    80005d26:	ec6e                	sd	s11,24(sp)
    80005d28:	0100                	addi	s0,sp,128
    80005d2a:	8a2a                	mv	s4,a0
    80005d2c:	e40c                	sd	a1,8(s0)
    80005d2e:	e810                	sd	a2,16(s0)
    80005d30:	ec14                	sd	a3,24(s0)
    80005d32:	f018                	sd	a4,32(s0)
    80005d34:	f41c                	sd	a5,40(s0)
    80005d36:	03043823          	sd	a6,48(s0)
    80005d3a:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d3e:	0001cd97          	auipc	s11,0x1c
    80005d42:	132dad83          	lw	s11,306(s11) # 80021e70 <pr+0x18>
  if(locking)
    80005d46:	020d9b63          	bnez	s11,80005d7c <printf+0x70>
  if (fmt == 0)
    80005d4a:	040a0263          	beqz	s4,80005d8e <printf+0x82>
  va_start(ap, fmt);
    80005d4e:	00840793          	addi	a5,s0,8
    80005d52:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d56:	000a4503          	lbu	a0,0(s4)
    80005d5a:	16050263          	beqz	a0,80005ebe <printf+0x1b2>
    80005d5e:	4481                	li	s1,0
    if(c != '%'){
    80005d60:	02500a93          	li	s5,37
    switch(c){
    80005d64:	07000b13          	li	s6,112
  consputc('x');
    80005d68:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d6a:	00003b97          	auipc	s7,0x3
    80005d6e:	bfeb8b93          	addi	s7,s7,-1026 # 80008968 <digits>
    switch(c){
    80005d72:	07300c93          	li	s9,115
    80005d76:	06400c13          	li	s8,100
    80005d7a:	a82d                	j	80005db4 <printf+0xa8>
    acquire(&pr.lock);
    80005d7c:	0001c517          	auipc	a0,0x1c
    80005d80:	0dc50513          	addi	a0,a0,220 # 80021e58 <pr>
    80005d84:	00000097          	auipc	ra,0x0
    80005d88:	488080e7          	jalr	1160(ra) # 8000620c <acquire>
    80005d8c:	bf7d                	j	80005d4a <printf+0x3e>
    panic("null fmt");
    80005d8e:	00003517          	auipc	a0,0x3
    80005d92:	bc250513          	addi	a0,a0,-1086 # 80008950 <syscallnames+0x408>
    80005d96:	00000097          	auipc	ra,0x0
    80005d9a:	f2c080e7          	jalr	-212(ra) # 80005cc2 <panic>
      consputc(c);
    80005d9e:	00000097          	auipc	ra,0x0
    80005da2:	c62080e7          	jalr	-926(ra) # 80005a00 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005da6:	2485                	addiw	s1,s1,1
    80005da8:	009a07b3          	add	a5,s4,s1
    80005dac:	0007c503          	lbu	a0,0(a5)
    80005db0:	10050763          	beqz	a0,80005ebe <printf+0x1b2>
    if(c != '%'){
    80005db4:	ff5515e3          	bne	a0,s5,80005d9e <printf+0x92>
    c = fmt[++i] & 0xff;
    80005db8:	2485                	addiw	s1,s1,1
    80005dba:	009a07b3          	add	a5,s4,s1
    80005dbe:	0007c783          	lbu	a5,0(a5)
    80005dc2:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005dc6:	cfe5                	beqz	a5,80005ebe <printf+0x1b2>
    switch(c){
    80005dc8:	05678a63          	beq	a5,s6,80005e1c <printf+0x110>
    80005dcc:	02fb7663          	bgeu	s6,a5,80005df8 <printf+0xec>
    80005dd0:	09978963          	beq	a5,s9,80005e62 <printf+0x156>
    80005dd4:	07800713          	li	a4,120
    80005dd8:	0ce79863          	bne	a5,a4,80005ea8 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005ddc:	f8843783          	ld	a5,-120(s0)
    80005de0:	00878713          	addi	a4,a5,8
    80005de4:	f8e43423          	sd	a4,-120(s0)
    80005de8:	4605                	li	a2,1
    80005dea:	85ea                	mv	a1,s10
    80005dec:	4388                	lw	a0,0(a5)
    80005dee:	00000097          	auipc	ra,0x0
    80005df2:	e32080e7          	jalr	-462(ra) # 80005c20 <printint>
      break;
    80005df6:	bf45                	j	80005da6 <printf+0x9a>
    switch(c){
    80005df8:	0b578263          	beq	a5,s5,80005e9c <printf+0x190>
    80005dfc:	0b879663          	bne	a5,s8,80005ea8 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005e00:	f8843783          	ld	a5,-120(s0)
    80005e04:	00878713          	addi	a4,a5,8
    80005e08:	f8e43423          	sd	a4,-120(s0)
    80005e0c:	4605                	li	a2,1
    80005e0e:	45a9                	li	a1,10
    80005e10:	4388                	lw	a0,0(a5)
    80005e12:	00000097          	auipc	ra,0x0
    80005e16:	e0e080e7          	jalr	-498(ra) # 80005c20 <printint>
      break;
    80005e1a:	b771                	j	80005da6 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005e1c:	f8843783          	ld	a5,-120(s0)
    80005e20:	00878713          	addi	a4,a5,8
    80005e24:	f8e43423          	sd	a4,-120(s0)
    80005e28:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005e2c:	03000513          	li	a0,48
    80005e30:	00000097          	auipc	ra,0x0
    80005e34:	bd0080e7          	jalr	-1072(ra) # 80005a00 <consputc>
  consputc('x');
    80005e38:	07800513          	li	a0,120
    80005e3c:	00000097          	auipc	ra,0x0
    80005e40:	bc4080e7          	jalr	-1084(ra) # 80005a00 <consputc>
    80005e44:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e46:	03c9d793          	srli	a5,s3,0x3c
    80005e4a:	97de                	add	a5,a5,s7
    80005e4c:	0007c503          	lbu	a0,0(a5)
    80005e50:	00000097          	auipc	ra,0x0
    80005e54:	bb0080e7          	jalr	-1104(ra) # 80005a00 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005e58:	0992                	slli	s3,s3,0x4
    80005e5a:	397d                	addiw	s2,s2,-1
    80005e5c:	fe0915e3          	bnez	s2,80005e46 <printf+0x13a>
    80005e60:	b799                	j	80005da6 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005e62:	f8843783          	ld	a5,-120(s0)
    80005e66:	00878713          	addi	a4,a5,8
    80005e6a:	f8e43423          	sd	a4,-120(s0)
    80005e6e:	0007b903          	ld	s2,0(a5)
    80005e72:	00090e63          	beqz	s2,80005e8e <printf+0x182>
      for(; *s; s++)
    80005e76:	00094503          	lbu	a0,0(s2)
    80005e7a:	d515                	beqz	a0,80005da6 <printf+0x9a>
        consputc(*s);
    80005e7c:	00000097          	auipc	ra,0x0
    80005e80:	b84080e7          	jalr	-1148(ra) # 80005a00 <consputc>
      for(; *s; s++)
    80005e84:	0905                	addi	s2,s2,1
    80005e86:	00094503          	lbu	a0,0(s2)
    80005e8a:	f96d                	bnez	a0,80005e7c <printf+0x170>
    80005e8c:	bf29                	j	80005da6 <printf+0x9a>
        s = "(null)";
    80005e8e:	00003917          	auipc	s2,0x3
    80005e92:	aba90913          	addi	s2,s2,-1350 # 80008948 <syscallnames+0x400>
      for(; *s; s++)
    80005e96:	02800513          	li	a0,40
    80005e9a:	b7cd                	j	80005e7c <printf+0x170>
      consputc('%');
    80005e9c:	8556                	mv	a0,s5
    80005e9e:	00000097          	auipc	ra,0x0
    80005ea2:	b62080e7          	jalr	-1182(ra) # 80005a00 <consputc>
      break;
    80005ea6:	b701                	j	80005da6 <printf+0x9a>
      consputc('%');
    80005ea8:	8556                	mv	a0,s5
    80005eaa:	00000097          	auipc	ra,0x0
    80005eae:	b56080e7          	jalr	-1194(ra) # 80005a00 <consputc>
      consputc(c);
    80005eb2:	854a                	mv	a0,s2
    80005eb4:	00000097          	auipc	ra,0x0
    80005eb8:	b4c080e7          	jalr	-1204(ra) # 80005a00 <consputc>
      break;
    80005ebc:	b5ed                	j	80005da6 <printf+0x9a>
  if(locking)
    80005ebe:	020d9163          	bnez	s11,80005ee0 <printf+0x1d4>
}
    80005ec2:	70e6                	ld	ra,120(sp)
    80005ec4:	7446                	ld	s0,112(sp)
    80005ec6:	74a6                	ld	s1,104(sp)
    80005ec8:	7906                	ld	s2,96(sp)
    80005eca:	69e6                	ld	s3,88(sp)
    80005ecc:	6a46                	ld	s4,80(sp)
    80005ece:	6aa6                	ld	s5,72(sp)
    80005ed0:	6b06                	ld	s6,64(sp)
    80005ed2:	7be2                	ld	s7,56(sp)
    80005ed4:	7c42                	ld	s8,48(sp)
    80005ed6:	7ca2                	ld	s9,40(sp)
    80005ed8:	7d02                	ld	s10,32(sp)
    80005eda:	6de2                	ld	s11,24(sp)
    80005edc:	6129                	addi	sp,sp,192
    80005ede:	8082                	ret
    release(&pr.lock);
    80005ee0:	0001c517          	auipc	a0,0x1c
    80005ee4:	f7850513          	addi	a0,a0,-136 # 80021e58 <pr>
    80005ee8:	00000097          	auipc	ra,0x0
    80005eec:	3d8080e7          	jalr	984(ra) # 800062c0 <release>
}
    80005ef0:	bfc9                	j	80005ec2 <printf+0x1b6>

0000000080005ef2 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005ef2:	1101                	addi	sp,sp,-32
    80005ef4:	ec06                	sd	ra,24(sp)
    80005ef6:	e822                	sd	s0,16(sp)
    80005ef8:	e426                	sd	s1,8(sp)
    80005efa:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005efc:	0001c497          	auipc	s1,0x1c
    80005f00:	f5c48493          	addi	s1,s1,-164 # 80021e58 <pr>
    80005f04:	00003597          	auipc	a1,0x3
    80005f08:	a5c58593          	addi	a1,a1,-1444 # 80008960 <syscallnames+0x418>
    80005f0c:	8526                	mv	a0,s1
    80005f0e:	00000097          	auipc	ra,0x0
    80005f12:	26e080e7          	jalr	622(ra) # 8000617c <initlock>
  pr.locking = 1;
    80005f16:	4785                	li	a5,1
    80005f18:	cc9c                	sw	a5,24(s1)
}
    80005f1a:	60e2                	ld	ra,24(sp)
    80005f1c:	6442                	ld	s0,16(sp)
    80005f1e:	64a2                	ld	s1,8(sp)
    80005f20:	6105                	addi	sp,sp,32
    80005f22:	8082                	ret

0000000080005f24 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005f24:	1141                	addi	sp,sp,-16
    80005f26:	e406                	sd	ra,8(sp)
    80005f28:	e022                	sd	s0,0(sp)
    80005f2a:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f2c:	100007b7          	lui	a5,0x10000
    80005f30:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f34:	f8000713          	li	a4,-128
    80005f38:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f3c:	470d                	li	a4,3
    80005f3e:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f42:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f46:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f4a:	469d                	li	a3,7
    80005f4c:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f50:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f54:	00003597          	auipc	a1,0x3
    80005f58:	a2c58593          	addi	a1,a1,-1492 # 80008980 <digits+0x18>
    80005f5c:	0001c517          	auipc	a0,0x1c
    80005f60:	f1c50513          	addi	a0,a0,-228 # 80021e78 <uart_tx_lock>
    80005f64:	00000097          	auipc	ra,0x0
    80005f68:	218080e7          	jalr	536(ra) # 8000617c <initlock>
}
    80005f6c:	60a2                	ld	ra,8(sp)
    80005f6e:	6402                	ld	s0,0(sp)
    80005f70:	0141                	addi	sp,sp,16
    80005f72:	8082                	ret

0000000080005f74 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f74:	1101                	addi	sp,sp,-32
    80005f76:	ec06                	sd	ra,24(sp)
    80005f78:	e822                	sd	s0,16(sp)
    80005f7a:	e426                	sd	s1,8(sp)
    80005f7c:	1000                	addi	s0,sp,32
    80005f7e:	84aa                	mv	s1,a0
  push_off();
    80005f80:	00000097          	auipc	ra,0x0
    80005f84:	240080e7          	jalr	576(ra) # 800061c0 <push_off>

  if(panicked){
    80005f88:	00003797          	auipc	a5,0x3
    80005f8c:	aa47a783          	lw	a5,-1372(a5) # 80008a2c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f90:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f94:	c391                	beqz	a5,80005f98 <uartputc_sync+0x24>
    for(;;)
    80005f96:	a001                	j	80005f96 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f98:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f9c:	0ff7f793          	andi	a5,a5,255
    80005fa0:	0207f793          	andi	a5,a5,32
    80005fa4:	dbf5                	beqz	a5,80005f98 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005fa6:	0ff4f793          	andi	a5,s1,255
    80005faa:	10000737          	lui	a4,0x10000
    80005fae:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80005fb2:	00000097          	auipc	ra,0x0
    80005fb6:	2ae080e7          	jalr	686(ra) # 80006260 <pop_off>
}
    80005fba:	60e2                	ld	ra,24(sp)
    80005fbc:	6442                	ld	s0,16(sp)
    80005fbe:	64a2                	ld	s1,8(sp)
    80005fc0:	6105                	addi	sp,sp,32
    80005fc2:	8082                	ret

0000000080005fc4 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005fc4:	00003717          	auipc	a4,0x3
    80005fc8:	a6c73703          	ld	a4,-1428(a4) # 80008a30 <uart_tx_r>
    80005fcc:	00003797          	auipc	a5,0x3
    80005fd0:	a6c7b783          	ld	a5,-1428(a5) # 80008a38 <uart_tx_w>
    80005fd4:	06e78c63          	beq	a5,a4,8000604c <uartstart+0x88>
{
    80005fd8:	7139                	addi	sp,sp,-64
    80005fda:	fc06                	sd	ra,56(sp)
    80005fdc:	f822                	sd	s0,48(sp)
    80005fde:	f426                	sd	s1,40(sp)
    80005fe0:	f04a                	sd	s2,32(sp)
    80005fe2:	ec4e                	sd	s3,24(sp)
    80005fe4:	e852                	sd	s4,16(sp)
    80005fe6:	e456                	sd	s5,8(sp)
    80005fe8:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fea:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fee:	0001ca17          	auipc	s4,0x1c
    80005ff2:	e8aa0a13          	addi	s4,s4,-374 # 80021e78 <uart_tx_lock>
    uart_tx_r += 1;
    80005ff6:	00003497          	auipc	s1,0x3
    80005ffa:	a3a48493          	addi	s1,s1,-1478 # 80008a30 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005ffe:	00003997          	auipc	s3,0x3
    80006002:	a3a98993          	addi	s3,s3,-1478 # 80008a38 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006006:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000600a:	0ff7f793          	andi	a5,a5,255
    8000600e:	0207f793          	andi	a5,a5,32
    80006012:	c785                	beqz	a5,8000603a <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006014:	01f77793          	andi	a5,a4,31
    80006018:	97d2                	add	a5,a5,s4
    8000601a:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    8000601e:	0705                	addi	a4,a4,1
    80006020:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006022:	8526                	mv	a0,s1
    80006024:	ffffb097          	auipc	ra,0xffffb
    80006028:	5b8080e7          	jalr	1464(ra) # 800015dc <wakeup>
    
    WriteReg(THR, c);
    8000602c:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006030:	6098                	ld	a4,0(s1)
    80006032:	0009b783          	ld	a5,0(s3)
    80006036:	fce798e3          	bne	a5,a4,80006006 <uartstart+0x42>
  }
}
    8000603a:	70e2                	ld	ra,56(sp)
    8000603c:	7442                	ld	s0,48(sp)
    8000603e:	74a2                	ld	s1,40(sp)
    80006040:	7902                	ld	s2,32(sp)
    80006042:	69e2                	ld	s3,24(sp)
    80006044:	6a42                	ld	s4,16(sp)
    80006046:	6aa2                	ld	s5,8(sp)
    80006048:	6121                	addi	sp,sp,64
    8000604a:	8082                	ret
    8000604c:	8082                	ret

000000008000604e <uartputc>:
{
    8000604e:	7179                	addi	sp,sp,-48
    80006050:	f406                	sd	ra,40(sp)
    80006052:	f022                	sd	s0,32(sp)
    80006054:	ec26                	sd	s1,24(sp)
    80006056:	e84a                	sd	s2,16(sp)
    80006058:	e44e                	sd	s3,8(sp)
    8000605a:	e052                	sd	s4,0(sp)
    8000605c:	1800                	addi	s0,sp,48
    8000605e:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006060:	0001c517          	auipc	a0,0x1c
    80006064:	e1850513          	addi	a0,a0,-488 # 80021e78 <uart_tx_lock>
    80006068:	00000097          	auipc	ra,0x0
    8000606c:	1a4080e7          	jalr	420(ra) # 8000620c <acquire>
  if(panicked){
    80006070:	00003797          	auipc	a5,0x3
    80006074:	9bc7a783          	lw	a5,-1604(a5) # 80008a2c <panicked>
    80006078:	e7c9                	bnez	a5,80006102 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000607a:	00003797          	auipc	a5,0x3
    8000607e:	9be7b783          	ld	a5,-1602(a5) # 80008a38 <uart_tx_w>
    80006082:	00003717          	auipc	a4,0x3
    80006086:	9ae73703          	ld	a4,-1618(a4) # 80008a30 <uart_tx_r>
    8000608a:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000608e:	0001ca17          	auipc	s4,0x1c
    80006092:	deaa0a13          	addi	s4,s4,-534 # 80021e78 <uart_tx_lock>
    80006096:	00003497          	auipc	s1,0x3
    8000609a:	99a48493          	addi	s1,s1,-1638 # 80008a30 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000609e:	00003917          	auipc	s2,0x3
    800060a2:	99a90913          	addi	s2,s2,-1638 # 80008a38 <uart_tx_w>
    800060a6:	00f71f63          	bne	a4,a5,800060c4 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    800060aa:	85d2                	mv	a1,s4
    800060ac:	8526                	mv	a0,s1
    800060ae:	ffffb097          	auipc	ra,0xffffb
    800060b2:	4ca080e7          	jalr	1226(ra) # 80001578 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060b6:	00093783          	ld	a5,0(s2)
    800060ba:	6098                	ld	a4,0(s1)
    800060bc:	02070713          	addi	a4,a4,32
    800060c0:	fef705e3          	beq	a4,a5,800060aa <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800060c4:	0001c497          	auipc	s1,0x1c
    800060c8:	db448493          	addi	s1,s1,-588 # 80021e78 <uart_tx_lock>
    800060cc:	01f7f713          	andi	a4,a5,31
    800060d0:	9726                	add	a4,a4,s1
    800060d2:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    800060d6:	0785                	addi	a5,a5,1
    800060d8:	00003717          	auipc	a4,0x3
    800060dc:	96f73023          	sd	a5,-1696(a4) # 80008a38 <uart_tx_w>
  uartstart();
    800060e0:	00000097          	auipc	ra,0x0
    800060e4:	ee4080e7          	jalr	-284(ra) # 80005fc4 <uartstart>
  release(&uart_tx_lock);
    800060e8:	8526                	mv	a0,s1
    800060ea:	00000097          	auipc	ra,0x0
    800060ee:	1d6080e7          	jalr	470(ra) # 800062c0 <release>
}
    800060f2:	70a2                	ld	ra,40(sp)
    800060f4:	7402                	ld	s0,32(sp)
    800060f6:	64e2                	ld	s1,24(sp)
    800060f8:	6942                	ld	s2,16(sp)
    800060fa:	69a2                	ld	s3,8(sp)
    800060fc:	6a02                	ld	s4,0(sp)
    800060fe:	6145                	addi	sp,sp,48
    80006100:	8082                	ret
    for(;;)
    80006102:	a001                	j	80006102 <uartputc+0xb4>

0000000080006104 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006104:	1141                	addi	sp,sp,-16
    80006106:	e422                	sd	s0,8(sp)
    80006108:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000610a:	100007b7          	lui	a5,0x10000
    8000610e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006112:	8b85                	andi	a5,a5,1
    80006114:	cb91                	beqz	a5,80006128 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006116:	100007b7          	lui	a5,0x10000
    8000611a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000611e:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006122:	6422                	ld	s0,8(sp)
    80006124:	0141                	addi	sp,sp,16
    80006126:	8082                	ret
    return -1;
    80006128:	557d                	li	a0,-1
    8000612a:	bfe5                	j	80006122 <uartgetc+0x1e>

000000008000612c <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000612c:	1101                	addi	sp,sp,-32
    8000612e:	ec06                	sd	ra,24(sp)
    80006130:	e822                	sd	s0,16(sp)
    80006132:	e426                	sd	s1,8(sp)
    80006134:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006136:	54fd                	li	s1,-1
    int c = uartgetc();
    80006138:	00000097          	auipc	ra,0x0
    8000613c:	fcc080e7          	jalr	-52(ra) # 80006104 <uartgetc>
    if(c == -1)
    80006140:	00950763          	beq	a0,s1,8000614e <uartintr+0x22>
      break;
    consoleintr(c);
    80006144:	00000097          	auipc	ra,0x0
    80006148:	8fe080e7          	jalr	-1794(ra) # 80005a42 <consoleintr>
  while(1){
    8000614c:	b7f5                	j	80006138 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000614e:	0001c497          	auipc	s1,0x1c
    80006152:	d2a48493          	addi	s1,s1,-726 # 80021e78 <uart_tx_lock>
    80006156:	8526                	mv	a0,s1
    80006158:	00000097          	auipc	ra,0x0
    8000615c:	0b4080e7          	jalr	180(ra) # 8000620c <acquire>
  uartstart();
    80006160:	00000097          	auipc	ra,0x0
    80006164:	e64080e7          	jalr	-412(ra) # 80005fc4 <uartstart>
  release(&uart_tx_lock);
    80006168:	8526                	mv	a0,s1
    8000616a:	00000097          	auipc	ra,0x0
    8000616e:	156080e7          	jalr	342(ra) # 800062c0 <release>
}
    80006172:	60e2                	ld	ra,24(sp)
    80006174:	6442                	ld	s0,16(sp)
    80006176:	64a2                	ld	s1,8(sp)
    80006178:	6105                	addi	sp,sp,32
    8000617a:	8082                	ret

000000008000617c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000617c:	1141                	addi	sp,sp,-16
    8000617e:	e422                	sd	s0,8(sp)
    80006180:	0800                	addi	s0,sp,16
  lk->name = name;
    80006182:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006184:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006188:	00053823          	sd	zero,16(a0)
}
    8000618c:	6422                	ld	s0,8(sp)
    8000618e:	0141                	addi	sp,sp,16
    80006190:	8082                	ret

0000000080006192 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006192:	411c                	lw	a5,0(a0)
    80006194:	e399                	bnez	a5,8000619a <holding+0x8>
    80006196:	4501                	li	a0,0
  return r;
}
    80006198:	8082                	ret
{
    8000619a:	1101                	addi	sp,sp,-32
    8000619c:	ec06                	sd	ra,24(sp)
    8000619e:	e822                	sd	s0,16(sp)
    800061a0:	e426                	sd	s1,8(sp)
    800061a2:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800061a4:	6904                	ld	s1,16(a0)
    800061a6:	ffffb097          	auipc	ra,0xffffb
    800061aa:	c96080e7          	jalr	-874(ra) # 80000e3c <mycpu>
    800061ae:	40a48533          	sub	a0,s1,a0
    800061b2:	00153513          	seqz	a0,a0
}
    800061b6:	60e2                	ld	ra,24(sp)
    800061b8:	6442                	ld	s0,16(sp)
    800061ba:	64a2                	ld	s1,8(sp)
    800061bc:	6105                	addi	sp,sp,32
    800061be:	8082                	ret

00000000800061c0 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800061c0:	1101                	addi	sp,sp,-32
    800061c2:	ec06                	sd	ra,24(sp)
    800061c4:	e822                	sd	s0,16(sp)
    800061c6:	e426                	sd	s1,8(sp)
    800061c8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061ca:	100024f3          	csrr	s1,sstatus
    800061ce:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800061d2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800061d4:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800061d8:	ffffb097          	auipc	ra,0xffffb
    800061dc:	c64080e7          	jalr	-924(ra) # 80000e3c <mycpu>
    800061e0:	5d3c                	lw	a5,120(a0)
    800061e2:	cf89                	beqz	a5,800061fc <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800061e4:	ffffb097          	auipc	ra,0xffffb
    800061e8:	c58080e7          	jalr	-936(ra) # 80000e3c <mycpu>
    800061ec:	5d3c                	lw	a5,120(a0)
    800061ee:	2785                	addiw	a5,a5,1
    800061f0:	dd3c                	sw	a5,120(a0)
}
    800061f2:	60e2                	ld	ra,24(sp)
    800061f4:	6442                	ld	s0,16(sp)
    800061f6:	64a2                	ld	s1,8(sp)
    800061f8:	6105                	addi	sp,sp,32
    800061fa:	8082                	ret
    mycpu()->intena = old;
    800061fc:	ffffb097          	auipc	ra,0xffffb
    80006200:	c40080e7          	jalr	-960(ra) # 80000e3c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006204:	8085                	srli	s1,s1,0x1
    80006206:	8885                	andi	s1,s1,1
    80006208:	dd64                	sw	s1,124(a0)
    8000620a:	bfe9                	j	800061e4 <push_off+0x24>

000000008000620c <acquire>:
{
    8000620c:	1101                	addi	sp,sp,-32
    8000620e:	ec06                	sd	ra,24(sp)
    80006210:	e822                	sd	s0,16(sp)
    80006212:	e426                	sd	s1,8(sp)
    80006214:	1000                	addi	s0,sp,32
    80006216:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006218:	00000097          	auipc	ra,0x0
    8000621c:	fa8080e7          	jalr	-88(ra) # 800061c0 <push_off>
  if(holding(lk))
    80006220:	8526                	mv	a0,s1
    80006222:	00000097          	auipc	ra,0x0
    80006226:	f70080e7          	jalr	-144(ra) # 80006192 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000622a:	4705                	li	a4,1
  if(holding(lk))
    8000622c:	e115                	bnez	a0,80006250 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000622e:	87ba                	mv	a5,a4
    80006230:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006234:	2781                	sext.w	a5,a5
    80006236:	ffe5                	bnez	a5,8000622e <acquire+0x22>
  __sync_synchronize();
    80006238:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000623c:	ffffb097          	auipc	ra,0xffffb
    80006240:	c00080e7          	jalr	-1024(ra) # 80000e3c <mycpu>
    80006244:	e888                	sd	a0,16(s1)
}
    80006246:	60e2                	ld	ra,24(sp)
    80006248:	6442                	ld	s0,16(sp)
    8000624a:	64a2                	ld	s1,8(sp)
    8000624c:	6105                	addi	sp,sp,32
    8000624e:	8082                	ret
    panic("acquire");
    80006250:	00002517          	auipc	a0,0x2
    80006254:	73850513          	addi	a0,a0,1848 # 80008988 <digits+0x20>
    80006258:	00000097          	auipc	ra,0x0
    8000625c:	a6a080e7          	jalr	-1430(ra) # 80005cc2 <panic>

0000000080006260 <pop_off>:

void
pop_off(void)
{
    80006260:	1141                	addi	sp,sp,-16
    80006262:	e406                	sd	ra,8(sp)
    80006264:	e022                	sd	s0,0(sp)
    80006266:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006268:	ffffb097          	auipc	ra,0xffffb
    8000626c:	bd4080e7          	jalr	-1068(ra) # 80000e3c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006270:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006274:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006276:	e78d                	bnez	a5,800062a0 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006278:	5d3c                	lw	a5,120(a0)
    8000627a:	02f05b63          	blez	a5,800062b0 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000627e:	37fd                	addiw	a5,a5,-1
    80006280:	0007871b          	sext.w	a4,a5
    80006284:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006286:	eb09                	bnez	a4,80006298 <pop_off+0x38>
    80006288:	5d7c                	lw	a5,124(a0)
    8000628a:	c799                	beqz	a5,80006298 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000628c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006290:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006294:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006298:	60a2                	ld	ra,8(sp)
    8000629a:	6402                	ld	s0,0(sp)
    8000629c:	0141                	addi	sp,sp,16
    8000629e:	8082                	ret
    panic("pop_off - interruptible");
    800062a0:	00002517          	auipc	a0,0x2
    800062a4:	6f050513          	addi	a0,a0,1776 # 80008990 <digits+0x28>
    800062a8:	00000097          	auipc	ra,0x0
    800062ac:	a1a080e7          	jalr	-1510(ra) # 80005cc2 <panic>
    panic("pop_off");
    800062b0:	00002517          	auipc	a0,0x2
    800062b4:	6f850513          	addi	a0,a0,1784 # 800089a8 <digits+0x40>
    800062b8:	00000097          	auipc	ra,0x0
    800062bc:	a0a080e7          	jalr	-1526(ra) # 80005cc2 <panic>

00000000800062c0 <release>:
{
    800062c0:	1101                	addi	sp,sp,-32
    800062c2:	ec06                	sd	ra,24(sp)
    800062c4:	e822                	sd	s0,16(sp)
    800062c6:	e426                	sd	s1,8(sp)
    800062c8:	1000                	addi	s0,sp,32
    800062ca:	84aa                	mv	s1,a0
  if(!holding(lk))
    800062cc:	00000097          	auipc	ra,0x0
    800062d0:	ec6080e7          	jalr	-314(ra) # 80006192 <holding>
    800062d4:	c115                	beqz	a0,800062f8 <release+0x38>
  lk->cpu = 0;
    800062d6:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800062da:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800062de:	0f50000f          	fence	iorw,ow
    800062e2:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800062e6:	00000097          	auipc	ra,0x0
    800062ea:	f7a080e7          	jalr	-134(ra) # 80006260 <pop_off>
}
    800062ee:	60e2                	ld	ra,24(sp)
    800062f0:	6442                	ld	s0,16(sp)
    800062f2:	64a2                	ld	s1,8(sp)
    800062f4:	6105                	addi	sp,sp,32
    800062f6:	8082                	ret
    panic("release");
    800062f8:	00002517          	auipc	a0,0x2
    800062fc:	6b850513          	addi	a0,a0,1720 # 800089b0 <digits+0x48>
    80006300:	00000097          	auipc	ra,0x0
    80006304:	9c2080e7          	jalr	-1598(ra) # 80005cc2 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
