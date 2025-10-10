# [PREAMBLE]

	Thanks for taking interest in pax! This project enables a Linux distro
	to have a package management system. While obviously not for the large
	players due to their own implementations, this one has a target market
	aimed at smaller players like TinyCore and XiniX. Considering it is a
	single file, it does have an impressive feature set. While there is a
	larger set of TODO, the below is a priority short-list.

		TODO
		- make package naming generic using schemas
		- implement package building using 'builder'
		- enable database queries alongside filenames
		- optional automated package update checks
		- add permission checks before installations

	WARNING: currently this software is limited in use to only XiniX or
	TinyCore (using a config file) Linux distros. We will expand beyond
	this in time - patches are welcomed from the community to expedite
	this timeline.




# [FOR THE IMPATIENT]

	To Install:
		1. cd /path/to/pax
		2. sudo cp ./pax /bin

	To Use:
		1. pax --help




# [USEFUL FEATURES]

	Being a single file usually does not include a rich feature set, but
	this script was able to pack quite a bit in! Here's a short list of
	some rather robust actions that can be performed:

		o Install or (read-only) link package contents to filesystem
		o Copying packages to another folder or (storage) device
		o Create a software package, with optionally compiling
		o Create restore points allowing for restoration
		o List package dependency tree
		o Installation of version specific packages
		o Unload installed packages
		o Validate package data integrity and dependency tree
		o Can proxy installation from offline to online device




# [EXAMPLE ACTIONS]

	Install a package:
	     pax -i nano[.i32.bin.soft] [/path/to/local/file]

	Install packages from a file:
	     pax -i /path/to/package.list

	Install a specific version:
	     pax -i -V 1.2.3 nano[.i32.bin.soft] [/path/to/local/file]

	Make a package for distribution:
	     pax -m nano /path/to/package[/source]

	Only download a package from the repo:
	     pax -d nano[.i32.bin.soft]

	Update a package with optional restore point:
	     pax -i [-R] nano[.i32.bin.soft]

	Unload a package:
	     pax -u nano[.i32.bin.soft]

	Uninstall a package:
	     pax -u nano[.i32.bin.soft]

	Uninstall a package, purging configs too:
	     pax -u -P nano[.i32.bin.soft]




# [FUTURE DEV TIMELINE]

	Since we are working with several many projects (13 on github alone),
	we are going to provide an anticipated timeline of releases using
	internal staff. Obviously outside contribution will advance these
	forecasted dates.

	2025 Oct - completion of ModuleMaker for webWorks
	2025 Dec - migration of existing webWorks modules using ModuleMaker
	2026 Jan - migration of Tracker into webWorks and deprecation of
	           of standalone project
	2026 Feb - update paged to 2018 code base from ACME
	         - update pax to work with (TC) TinyCore Linux
	         - apply any patches for bug fixes to existing projects
	2026 Mar - update web.libs for dittodata and web.de
	2026 Jul - move code from web.de into cli.de and update the former
	           to use the latter via XML communication
	2026     - rest of 2026 tbd

