/* Talisker: Personality Kit Runtime Start-up
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

.globl start

/* Unlike normal function entry, the 'start' routine passes parameters
 * exclusively on the stack. Therefore we need to extract them from
 * that stack frame and copy the values into registers.
 *
 * On Darwin, the kernel passes an additional 'apple' parameter which is
 * a pointer located after the terminating NULL of envp, but we don't
 * currently use this.
 *
 * The stack on entry looks like this:
 *
 * +--------------------+
 * | apple              |
 * | envp[n] = NULL     |
 * :                    :
 * | envp[0]            |
 * | argv[argc] = NULL  |
 * :                    :
 * | argv[0]            |
 * | argc (32-bit int)  | <--- %rsp
 * +--------------------+
 *
 * Note that on Darwin, calls are made directly rather than by taking the address from the GOT;
 * the linker ensures that the relocations fall within the lower 2GB of address space so can be
 * fixed up from REL32 calls when required.
 *
 * https://developer.apple.com/library/content/documentation/DeveloperTools/Conceptual/MachOTopics/1-Articles/x86_64_code.html
 */

start:
	/* Ensure the debugger knows this is the top stack frame */
	pushq $0
	
	movq %rsp,%rbp
	andq $-16,%rsp
	/* Copy argc to %rdi and &(argv[0]) to %rsi */
	movq 8(%rbp), %rdi
	leaq 16(%rbp), %rsi
	/* Copy envp to %rdx */
	movl %edi, %edx
	addl $1, %edx
	sall $3, %edx
	addq %rsi, %rdx
	call Talisker.PersonalityKit.__main
	/* Copy the return value of our main() wrapper to the first param of _exit() */
	movl %eax,%edi
	call Talisker.PersonalityKit.Executive._exit
	hlt

.subsections_via_symbols

#endif
