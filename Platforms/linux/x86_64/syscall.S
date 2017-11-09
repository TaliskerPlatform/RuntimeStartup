/* Talisker: Personality Kit Runtime Start-up testing support
 *
 * Note that this implementation is used ONLY when building the Runtime
 * Startup tests. The real implementation can be found in PersonalityKit's
 * Executive.framework.
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

/* Invoke a specific system call on Linux/x86-64 */

.text
.align 4

.globl Talisker.PersonalityKit.__set_errno

.globl Talisker.PersonalityKit.Executive.__syscall
.type Talisker.PersonalityKit.Executive.__syscall,%function
Talisker.PersonalityKit.Executive.__syscall:
	/* On entry, the x86-64 ABI specifies that arguments use %rdi, %rsi, %rdx,
	 * %rcx, %r8, %r9, with the remainder pushed onto the stack in reverse
	 * order.
	 *
	 * For syscall, the system call number is passed in %rax, with the
	 * parameters in %rdi, %rsi, %rdx, %r10, %r8 and %r9. Therefore, we must
	 * rotate the registers.
	 *
	 * See A.2.1 of http://www.x86-64.org/documentation/abi.pdf
	 */
	movq %rdi, %rax
	movq %rsi, %rdi
	movq %rdx, %rsi
	movq %rcx, %rdx
	movq %r8, %r10
	movq %r9, %r8
	movq 8(%rsp), %r9
	syscall
	/* If the carry flag is not set, skip straight to the return */
	jnb 2f
	/* Push the errno value into %rdi and call set_errno() */
	movq %rax, %rdi
#ifdef PIC
	movabs $Talisker.PersonalityKit.__set_errno@GOT, %r11
	call *(%r11, %r15)
#else /*PIC*/
	call Talisker.PersonalityKit.__set_errno
#endif /*!PIC*/
2:
	ret

.size Talisker.PersonalityKit.Executive.__syscall,.-Talisker.PersonalityKit.Executive.__syscall

.globl Talisker.PersonalityKit.Executive.__hlt
.type Talisker.PersonalityKit.Executive.__hlt,%function
Talisker.PersonalityKit.Executive.__hlt:
	hlt

.size Talisker.PersonalityKit.Executive.__hlt,.-Talisker.PersonalityKit.Executive.__hlt

#endif /*HOST_NATIVE*/
