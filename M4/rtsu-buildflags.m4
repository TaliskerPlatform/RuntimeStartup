dnl Talisker: Personality Kit Runtime Start-up

dnl Copyright 2017 Mo McRoberts.
dnl
dnl  Licensed under the Apache License, Version 2.0 (the "License");
dnl  you may not use this file except in compliance with the License.
dnl  You may obtain a copy of the License at
dnl
dnl      http://www.apache.org/licenses/LICENSE-2.0
dnl
dnl  Unless required by applicable law or agreed to in writing, software
dnl  distributed under the License is distributed on an "AS IS" BASIS,
dnl  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
dnl  See the License for the specific language governing permissions and
dnl  limitations under the License.

dnl - RTSU_CHECK_BUILDFLAGS()
AC_DEFUN([RTSU_CHECK_BUILDFLAGS],[
AC_REQUIRE([RTSU_CHECK_PLATFORM])dnl
AC_REQUIRE([RTSU_CHECK_ARCH])dnl

dnl We set and substitute several different kinds of flags which are used
dnl when building different parts of Personality Kit and the binaries
dnl which use it.

dnl Flags for tests linked against the framework:
dnl
dnl   tests_cppflags
dnl   tests_ldflags
dnl
dnl Flags for linking applications and libraries:
dnl
dnl   pk_rtsu_cppflags_static
dnl   pk_rtsu_cppflags_dynamic
dnl   pk_rtsu_ldflags_static
dnl   pk_rtsu_ldflags_dynamic
dnl   pk_rtsu_ldflags_pie
dnl   pk_rtsu_ldflags_dylib
dnl   pk_rtsu_ldflags_ldso

tests_cppflags=""
tests_ldflags=""
tests_libs=""

if test x"$native" = x"yes" ; then
	if test x"$GCC" =  x"yes" ; then
		tests_cppflags='-ffreestanding -fno-stack-protector'
		pk_rtsu_cppflags_static="-ffreestanding -static"
		pk_rtsu_cppflags_dynamic="-ffreestanding"
	fi
	case "$host_platform" in
		linux)
			tests_ldflags="-static -nostartfiles -nodefaultlibs"
			;;
		darwin)
			tests_ldflags="-static -nostartfiles -nodefaultlibs -Wl,-static"
			;;
	esac
fi
RTSU_SUBST_BUILDFLAG([tests_cppflags],[unit test preprocessor flags])
RTSU_SUBST_BUILDFLAG([tests_ldflags],[unit test linker flags])
RTSU_SUBST_BUILDFLAG([tests_libs],[unit test libraries])
])dnl

dnl - RTSU_SUBST_BUILDFLAG([NAME],[DESCRIPTION])
AC_DEFUN([RTSU_SUBST_BUILDFLAG],[
AC_SUBST([$1])
AC_MSG_CHECKING([$2])
val="$]$1["
test x"$val" = x"" && val="(none needed)"
AC_MSG_RESULT([$val])
])
