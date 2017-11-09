/* Talisker: Personality Kit Runtime Start-up testing support
 */

/* Copyright (c) 2017 Mo McRoberts.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

#ifdef HAVE_CONFIG_H
# include "config.h"
#endif

#if HOST_NATIVE

/* On Darwin, bits 31-24 are the system call "class" - Mach, BSD,
 * machine-dependent, diagnostics, or IPC. The actual system call
 * number passed in %rdi to the syscall instruction includes this
 * class. The values in <sys/syscall.h> don't include the class
 * value, so we define a macro here to binary-OR the appropriate
 * class
 */
# define DARWIN_SYSCALL_NR(sys_class, sys_num) \
	((((sys_class) & 0xFF) << 24) | ((~(0xFF << 24)) & (sys_num)))

# define SYSCALL_CLASS_MACH            1
# define SYSCALL_CLASS_UNIX            2
# define SYSCALL_CLASS_MACHINE         3
# define SYSCALL_CLASS_DIAG            4
# define SYSCALL_CLASS_IPC             5

extern int sys__syscall(int nr, ...) __asm__("Talisker.PersonalityKit.Executive.__syscall");

#undef SYS_write
#if defined(__linux__)
# if defined(__x86_64__)
#  define SYS_write                     1
# elif defined(__i386__)
#  define SYS_write                     4
# endif
#elif defined(__APPLE__)
#  define SYS_write                     DARWIN_SYSCALL_NR(SYSCALL_CLASS_UNIX, 4)
#endif

int
tal_write(int fd, const char *str, int len)
{
#ifdef SYS_write
	return sys__syscall(SYS_write, fd, str, len);
#else
# warning No system call number defined for write() on this platform
	return -1;
#endif
}

#else /*HOST_NATIVE*/

# include <unistd.h>
int
tal_write(int fd, const char *str, int len)
{
	return write(fd, str, len);
}

#endif /*!HOST_NATIVE*/

int
tal_puts(const char *str)
{
	int l;
	const char *bp;
	
	l = 0;
	for(bp = str; *bp; bp++)
	{
		l++;
	}
	return tal_write(1, str, l);
}

int
tal_putch(int ch)
{
	char buf[1];
	
	buf[0] = ch;
	return tal_write(1, buf, 1);
}

int
tal_putint(int n)
{
	char buffer[64], *p;
	int m;
	
	p = &buffer[63];
	*p = 0;
	do
	{
		p--;
		m = n % 10;
		n /= 10;
		*p = '0' + m;
	}
	while(n);
	return tal_puts(p);
}
