## Talisker: Personality Kit Runtime Start-up

## Copyright 2017 Mo McRoberts.
##
##  Licensed under the Apache License, Version 2.0 (the "License");
##  you may not use this file except in compliance with the License.
##  You may obtain a copy of the License at
##
##      http://www.apache.org/licenses/LICENSE-2.0
##
##  Unless required by applicable law or agreed to in writing, software
##  distributed under the License is distributed on an "AS IS" BASIS,
##  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##  See the License for the specific language governing permissions and
##  limitations under the License.

AC_INIT([RuntimeStartup],[develop])

AC_CONFIG_MACRO_DIR([M4])
AC_CONFIG_AUX_DIR([BuildScripts])

test x"$CPPFLAGS" = x"" && empty_cppflags=yes
test x"$CXXFLAGS" = x"" && empty_cxxflags=yes
test x"$CFLAGS" = x"" && empty_cflags=yes

AC_PREFIX_DEFAULT([/Preview])

AM_INIT_AUTOMAKE([foreign subdir-objects])
AM_MAINTAINER_MODE

AC_PROG_CC([clang c99 gcc cc])

RTSU_CANONICAL_HOST

AC_CONFIG_HEADER([config.h])

AM_PROG_AS
LT_INIT

if test x"$GCC" = x"yes" ; then
	test x"$empty_cppflags" = x"yes" && CPPFLAGS="$CPPFLAGS -W -Wall"
	test x"$empty_cflags" = x"yes" && CFLAGS="$CFLAGS -ggdb -O0"
	test x"$empty_cxxflags" = x"yes" && CXXFLAGS="$CXXFLAGS -ggdb -O0"
fi

RTSU_CHECK_BUILDFLAGS

AM_CONDITIONAL([BUILD_TESTS],[test $host_type = native || test $host_type = hosted])

AC_SUBST([AM_CPPFLAGS])
AC_SUBST([AM_CFLAGS])
AC_SUBST([AM_CXXFLAGS])

AC_CONFIG_FILES([
Makefile
PersonalityKit-RuntimeStartup-uninstalled.pc
Platforms/Makefile
Platforms/darwin/Makefile
Platforms/darwin/x86_64/Makefile
Platforms/linux/Makefile
Platforms/linux/x86_64/Makefile
Tests/Makefile
Tests/lib/Makefile
])

AC_OUTPUT
