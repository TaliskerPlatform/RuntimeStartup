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

m4_pattern_forbid([^_?RTSU_])

dnl - RTSU_CANONICAL_HOST()
AC_DEFUN([RTSU_CANONICAL_HOST],[
AC_REQUIRE([TAL_CANONICAL_HOST])dnl

if test x"$host_type" = x"freestanding" ; then
	AC_MSG_ERROR([cannot build the Runtime Start-up objects for a freestanding host (a kernel is required)])
fi

AC_MSG_CHECKING([whether this is a native build])
AC_ARG_ENABLE([native],[AS_HELP_STRING([--enable-native],[perform a native build (default=auto)])],[native=$enableval],[native=auto])
if test x"$native" = x"auto" ; then
	test x"$host_type" = x"native" && native=yes
	test x"$host_type" = x"native" || native=no
elif test x"$native" = x"no" && test x"$host_type" = x"native"; then
	AC_MSG_ERROR([cannot perform a non-native build with no host machine])
fi	
AC_SUBST([native])
if test x"$native" = x"yes" ; then
	# Override host_type and host_bindir to match user selections
	host_type="native"
	host_bindir='${host_family}-${host_platform}'
	AC_SUBST([host_type])
	AC_DEFINE_UNQUOTED([HOST_NATIVE],[1],[Defined if this is a native build])
fi
AC_MSG_RESULT([$native])
])dnl
