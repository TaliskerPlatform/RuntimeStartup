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

/* Provide a stub implementation of Talisker.PersonalityKit.Executive._exit() */

extern int sys__syscall(int nr, ...) __asm__("Talisker.PersonalityKit.Executive.__syscall");
extern void sys_exit(int status) __asm__("Talisker.PersonalityKit.Executive._exit");
extern void sys__hlt(void) __asm__("Talisker.PersonalityKit.Executive.__hlt");

#undef SYS_exit
#if defined(__linux__)
# if defined(__x86_64__)
#  define SYS_exit                     60
# elif defined(__i386__)
#  define SYS_exit                     1
# endif
#elif defined(__APPLE__)
#  define SYS_exit                     DARWIN_SYSCALL_NR(SYSCALL_CLASS_UNIX, 1)
#endif

void
sys_exit(int status)
{
#ifdef SYS_exit
	sys__syscall(SYS_exit, status);
#else
# warning No system call number defined for _exit() on this platform
#endif
	sys__hlt();
}

#endif /*HOST_NATIVE*/
