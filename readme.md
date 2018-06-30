# Description

VSTS build task to read chef cookbook version number from metadata.rb file

Reads the version number from metadata.rb into environment variables for use in incrementing cookbook versions.

Optionally prefix the variable values so multiple projects can be read.

Adapted from [AssemblyInfoReaderTask](https://github.com/kyleherzog/AssemblyInfoReaderTask) with thanks to [kyleherzog](https://github.com/kyleherzog)