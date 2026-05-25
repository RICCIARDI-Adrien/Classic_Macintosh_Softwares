# !/bin/sh

# Exit if any error occurs
set -e

PATH_SIT="$(realpath ../Tools/sit)"
BINARY_SIT="${PATH_SIT}/sit"

# Check the arguments
if [ $# -ne 2 ]
then
	printf "Usage : $0 Input_Directory Output_Archive_File\n"
	exit 1
fi
PARAMETER_INPUT_DIRECTORY=$1
PARAMETER_OUTPUT_ARCHIVE=$2

# Append the file extension if it is not present in the provided output file name
set +e # The grep command returns 1 if the searched text is not found
echo ${PARAMETER_OUTPUT_ARCHIVE} | grep '.sit\>'
if [ $? -ne 0 ]
then
	PARAMETER_OUTPUT_ARCHIVE_EXTENSION="${PARAMETER_OUTPUT_ARCHIVE}.sit"
	PARAMETER_OUTPUT_ARCHIVE=${PARAMETER_OUTPUT_ARCHIVE_EXTENSION}
	printf "Automatically added the \".sit\" extension to the output archive name.\n"
fi
set -e

# Check whether the "sit" tool is available
if [ ! -e ${BINARY_SIT} ]
then
	printf "Compiling the \"sit\" tool.\n"
	cd ${PATH_SIT} && make
fi

# Clear the previously existing archive
rm -f ${PARAMETER_OUTPUT_ARCHIVE}
# Create the archive with the specified name, set all files as text type and created by MPW
${BINARY_SIT} -v -u -o ${PARAMETER_OUTPUT_ARCHIVE} -T TEXT -C 'MPS ' ${PARAMETER_INPUT_DIRECTORY}
printf "The archive was successfully created.\n"
