dnl Talisker: Personality Kit Runtime start-up

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

dnl - RTSU_CHECK_ARCH()
AC_DEFUN([RTSU_CHECK_ARCH],[
AC_REQUIRE([RTSU_CHECK_PLATFORM])dnl
AC_MSG_CHECKING([for architecture-specific support for $host_type $host_platform on $host_family])
arch_subdir=''
arch_dir=''
arch_sources=''
arch_objs=''
arch_lib=''
if test x"$native" = x"yes" ; then
	if test -d "$srcdir/$platform_dir/$host_cpu" ; then
		AC_MSG_RESULT([yes ($host_cpu)])
		arch_subdir="$host_cpu"
		arch_dir="$platform_dir/$arch_subdir"
		arch_lib='${top_builddir}/${arch_dir}/librtsu.la'
	elif test -d "$srcdir/$platform_dir/$host_family" ; then
		AC_MSG_RESULT([yes ($host_family)])
		arch_subdir="$host_family"
		arch_dir="$platform_dir/$arch_subdir"
		arch_lib='${top_builddir}/${arch_dir}/librtsu.la'
	else
		AC_MSG_RESULT([no])
		AC_MSG_ERROR([cannot perform a native build for architecture $host_family which is not supported])
	fi
else
	AC_MSG_RESULT([none required for non-native build])
fi
AC_SUBST([arch_subdir])
AC_SUBST([arch_dir])
AC_SUBST([arch_sources])
AC_SUBST([arch_objs])
AC_SUBST([arch_lib])
])dnl
