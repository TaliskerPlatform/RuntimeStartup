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

SUBDIRS = lib .

AM_CPPFLAGS = @tests_cppflags@
AM_LDFLAGS = @tests_ldflags@ -all-static
LIBS = @arch_lib@ lib/libtests.la

if BUILD_TESTS

noinst_PROGRAMS = \
	t-return-0 t-return-123 t-return-argc t-print-args t-print-env

endif
