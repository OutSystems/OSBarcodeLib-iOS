### Welcome the user to this awesome tool

printf "Welcome to the iOS Library Generator!!\n\n"

remoteURL=$(git config --get remote.origin.url)
remoteURL=$(echo $remoteURL | perl -F/ -wane 'print $F[-1]')
remoteURL=$(echo ${remoteURL%-*})

### Inform the user of the library name to be used
printf "Considering the repository name you gave while creating it, we will use '$remoteURL' as the Library's name."

### Ask the user for the organisation identifier. Continue to ask while the input doesn't match the correct format.
while true
do
	printf "\nPlease write the desired organisation identifier that will compose its bundle identifier (along with the library's name). This should be composed only by lowercase letters, numbers and '.' (e.g. 'com.outsystems').\n"
    read organisationId
   	result=$(echo $organisationId | awk '/^[a-z0-9]+([\.]?[a-z0-9]+)*?$/')

   	if ! [ -z "$result" ]; then
   		break
   	else
   		printf "Format not valid. Please try again."
   	fi
done

### Delete current file
currentFile=$(basename "$0")

printf "\nThe '$currentFile' file will be removed as it should only be executed once.\n\n"

rm -f $currentFile

### Proceed to change all necessary placeholders

cd ..

LC_CTYPE=C && LANG=C && find . -type f -exec sed -e "s/LibTemplatePlaceholder/$remoteURL/g" -i '' '{}' ';'
LC_CTYPE=C && LANG=C && find . -depth -name '*LibTemplatePlaceholder*' -print0|while IFS= read -rd '' f; do mv -i "$f" "$(echo "$f"|sed -E "s/(.*)LibTemplatePlaceholder/\1$remoteURL/")"; done

LC_CTYPE=C && LANG=C && find . -type f -exec sed -e "s/organizationIDPlaceholder/$organisationId/g" -i '' '{}' ';'

### Commit and push
rm -f .git/index
git reset
git add .
git commit -m "Finish initialization by running the generator script."
git push

### Close
printf "\n###Applause###\n"
printf "Looks like everything's done. Enjoy!\n\n"
