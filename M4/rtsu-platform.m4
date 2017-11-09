dnl Talisker: Personality Kit Executive Framework

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

dnl - RTSU_CHECK_PLATFORM()
AC_DEFUN([RTSU_CHECK_PLATFORM],[
AC_REQUIRE([RTSU_CANONICAL_HOST])dnl
AC_MSG_CHECKING([for platform-specific support for $host_platform])
platform_subdir=''
platform_dir=''
if test x"$native" = x"yes" ; then
	if test -d "$srcdir/Platforms/$host_platform" ; then
		AC_MSG_RESULT([yes])
		platform_subdir="$host_platform"
		platform_dir="Platforms/$platform_subdir"
	else
		AC_MSG_RESULT([no])
		AC_MSG_ERROR([cannot perform a native build for an unsupported platform])
	fi
else
	AC_MSG_RESULT([none required for non-native build])
fi
AC_SUBST([platform_subdir])
AC_SUBST([platform_dir])
])dnl
