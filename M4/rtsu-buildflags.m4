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
	pk_rtsu_ldflags="-nostartfiles -nodefaultlibs"
	pk_rtsu_ldflags_static="${pk_rtsu_ldflags} -static"
	case "$host_platform" in
		darwin)
			pk_rtsu_ldflags_static="${pk_rtsu_ldflags} -static -Wl,-static"
			;;
	esac
	tests_ldflags="$pk_rtsu_ldflags_static"
	m4_foreach([objsuffix],[[],_debug,_profile],[
		m4_foreach([objtype],[s,d,p],[
			AS_VAR_SET([pk_rtsu_init_]objtype[]objsuffix,["$arch_dir/rtsu-init-]objtype[]objsuffix[.o"])
			AS_VAR_SET([pk_rtsu_fini_]objtype[]objsuffix,["$arch_dir/rtsu-fini-]objtype[]objsuffix[.o"])
		])
	])
	for file in crt0 crt1 crtbegin ; do
		if test -f ${srcdir}/${arch_dir}/${file}.S ; then
			AS_VAR_SET([pk_rtsu_init_lo],["${pk_rtsu_init_lo} $arch_dir/$file.lo]")
		fi
	done
	for file in crtend crtn ; do
		if test -f ${srcdir}/${arch_dir}/${file}.S ; then
			AS_VAR_SET([pk_rtsu_fini_lo],["${pk_rtsu_fini_lo} $arch_dir/$file.lo]")
		fi
	done
	AS_VAR_SET([pk_rtsu_libs_la],["${arch_dir}/librtsu.la"])
fi

AC_SUBST([pk_rtsu_init_lo])
AC_SUBST([pk_rtsu_fini_lo])
AC_SUBST([pk_rtsu_libs_la])
m4_foreach([objsuffix],[[],_debug,_profile],[
	m4_foreach([objtype],[s,d,p],[
		AC_SUBST([pk_rtsu_init_]objtype[]objsuffix)
		AC_SUBST([pk_rtsu_fini_]objtype[]objsuffix)
	])
])

RTSU_SUBST_BUILDFLAG([pk_rtsu_cppflags_static],[preprocessor flags for building static executables with this framework])
RTSU_SUBST_BUILDFLAG([pk_rtsu_cppflags_dynamic],[preprocessor flags for building dynamic executables with this framework])
RTSU_SUBST_BUILDFLAG([pk_rtsu_ldflags_static],[linker flags for building static executables with this framework])

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
