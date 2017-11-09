/* Talisker: Personality Kit Runtime Start-up (x86_64-linux)
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

#ifdef HOST_NATIVE

.text
.align 4

.globl Talisker.PersonalityKit.__main
.globl Talisker.PersonalityKit.Executive._exit
	
/* Unlike normal function entry, the '_start' routine passes parameters
 * exclusively on the stack. Therefore we need to extract them from
 * that stack frame and copy the values into registers.
 *
 * If a dynamic loader was involved in this executable, the address of
 * its cleanup routine (giving it the opportunity to invoke destructors)
 * is passed after envp.
 *
 * The stack on entry looks like this:
 *
 * +--------------------+
 * | dlfini             |
 * | envp[n] = NULL     |
 * :                    :
 * | envp[0]            |
 * | argv[argc] = NULL  |
 * :                    :
 * | argv[0]            |
 * | argc (32-bit int)  | <--- %rsp
 * +--------------------+
 */

.globl _start
.type _start, %function
_start:
	/* Ensure the debugger knows this is the top stack frame */
	pushq $0
	/* Store the head of the kernel stack area */
	movq %rsp,%rbp
	/* Ensure %rsp is properly aligned */
	andq $-16,%rsp
	/* Copy argc to %rdi and &(argv[0]) to %rsi */
	movq 8(%rbp), %rdi
	leaq 16(%rbp), %rsi
	/* Copy argc to %edx */
	movl %edi, %edx
	/* %edx++ to account for the NULL terminator */
	addl $1, %edx
	/* %edx += sizeof(char *) (via left-shift) */
	sall $3, %edx
	/* ...and use that as a byte offset relative to argv (%rsi), to
	 * store envp in %rdx
	 */
	addq %rsi, %rdx
# ifdef PIC
	call Talisker.PersonalityKit.__main@PLT
	/* Copy the return value of our main() to the first param of _exit() */
	movl %eax,%edi
	movabs $Talisker.PersonalityKit.Executive._exit@GOT, %r11
	call *(%r11, %r15)
# else /*PIC*/
	call Talisker.PersonalityKit.__main
	/* Copy the return value of main() to the first param of _exit() */
	movl %eax,%edi
	call Talisker.PersonalityKit.Executive._exit
#endif /*!PIC*/
	hlt

.size _start,.-_start

#endif
