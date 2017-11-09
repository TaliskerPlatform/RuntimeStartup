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

# We build a libtool library for use in compiling tests, and a non-libtool
# relocatble objects for all of the start-up (init) and finalisation
# (fini) code. There will be some overlap between the two in terms of
# which sources are built (otherwise the tests would be meaningless).

noinst_LTLIBRARIES = librtsu.la
librtsu_la_SOURCES = crt1.S crtn.S syscall.S
librtsu_la_SHORTNAME = l
librtsu_la_LINK = $(LIBTOOL) $(AM_V_lt) --tag=CC $(AM_LIBTOOLFLAGS) \
        $(LIBTOOLFLAGS) --mode=link $(CCLD) $(AM_CFLAGS) $(CFLAGS) \
        $(librtsu_la_LDFLAGS) $(LDFLAGS) -o $@

# Generate relocatable start-up and termination objects from crt1.S and
# crtn.S

LINK = $(LD) -r -o $@

noinst_PROGRAMS = \
	rtsu-init_d.o rtsu-init_s.o rtsu-init_p.o \
	rtsu-init_d_debug.o rtsu-init_s_debug.o rtsu-init_p_debug.o \
	rtsu-init_d_profile.o rtsu-init_s_profile.o rtsu-init_p_profile.o \
	rtsu-fini_d.o rtsu-fini_s.o rtsu-fini_p.o \
	rtsu-fini_d_debug.o rtsu-fini_s_debug.o rtsu-fini_p_debug.o \
	rtsu-fini_d_profile.o rtsu-fini_s_profile.o rtsu-fini_p_profile.o

rtsu_init_s_o_CPPFLAGS = -DSTATIC -DNDEBUG
rtsu_init_s_o_SOURCES = crt1.S

rtsu_init_d_o_CPPFLAGS = -DPIC -DNDEBUG
rtsu_init_d_o_SOURCES = crt1.S

rtsu_init_p_o_CPPFLAGS = -DPIE -DNDEBUG
rtsu_init_p_o_SOURCES = crt1.S

rtsu_init_s_debug_o_CPPFLAGS = -DSTATIC -DDEBUG
rtsu_init_s_debug_o_SOURCES = crt1.S

rtsu_init_d_debug_o_CPPFLAGS = -DPIC -DDEBUG
rtsu_init_d_debug_o_SOURCES = crt1.S

rtsu_init_p_debug_o_CPPFLAGS = -DPIE -DDEBUG
rtsu_init_p_debug_o_SOURCES = crt1.S

rtsu_init_s_profile_o_CPPFLAGS = -DSTATIC -DPROFILE
rtsu_init_s_profile_o_SOURCES = crt1.S

rtsu_init_d_profile_o_CPPFLAGS = -DPIC -DPROFILE
rtsu_init_d_profile_o_SOURCES = crt1.S

rtsu_init_p_profile_o_CPPFLAGS = -DPIE -DPROFILE
rtsu_init_p_profile_o_SOURCES = crt1.S

rtsu_fini_s_o_CPPFLAGS = -DSTATIC -DNDEBUG
rtsu_fini_s_o_SOURCES = crtn.S

rtsu_fini_d_o_CPPFLAGS = -DPIC -DNDEBUG
rtsu_fini_d_o_SOURCES = crtn.S

rtsu_fini_p_o_CPPFLAGS = -DPIE -DNDEBUG
rtsu_fini_p_o_SOURCES = crtn.S

rtsu_fini_s_debug_o_CPPFLAGS = -DSTATIC -DDEBUG
rtsu_fini_s_debug_o_SOURCES = crtn.S

rtsu_fini_d_debug_o_CPPFLAGS = -DPIC -DDEBUG
rtsu_fini_d_debug_o_SOURCES = crtn.S

rtsu_fini_p_debug_o_CPPFLAGS = -DPIE -DDEBUG
rtsu_fini_p_debug_o_SOURCES = crtn.S

rtsu_fini_s_profile_o_CPPFLAGS = -DSTATIC -DPROFILE
rtsu_fini_s_profile_o_SOURCES = crtn.S

rtsu_fini_d_profile_o_CPPFLAGS = -DPIC -DPROFILE
rtsu_fini_d_profile_o_SOURCES = crtn.S

rtsu_fini_p_profile_o_CPPFLAGS = -DPIE -DPROFILE
rtsu_fini_p_profile_o_SOURCES = crtn.S
