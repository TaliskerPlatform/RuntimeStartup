/* Talisker: Personality Kit Runtime Start-up (x86_64-linux)
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

extern int tal_putch(int ch);
extern int tal_puts(const char *str);
extern int tal_putint(int n);

int
main(int argc, char **argv, char **envp)
{
	int c;
	
	(void) envp;

	for(c = 0; c < argc; c++)
	{
		tal_putint(c);
		tal_putch(':');
		tal_putch(' ');
		tal_puts(argv[c]);
		tal_putch('\n');
	}
	return 0;
}
