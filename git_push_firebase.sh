#! /bin/bash

#get the repository we are working in
old_IFS=$IFS
IFS=$'\n'
line=($(cat ./.git/FETCH_HEAD))
IFS=$old_IFS
myline=${line[0]}
#echo $myline
tmp=${myline%%https*}
remainingline=$tmp
#echo $tmp
tmp=$(( ${#tmp} ))
myline2=${myline:$tmp}
repo=${myline2%%\'*}
echo repo is $repo
slashold=50
slashnew=0
repo="${repo/./>}"
while [ $slashold -ne $slashnew ]
do
  slashold=$slashnew
  tmp=${repo%%\/*}
  #echo $tmp
  slashnew=$(( ${#tmp} ))
  #echo $slashold and $slashnew
  repo="${repo/\//|}"

  #echo new repo is $repo
done

#Get the branch that we are working on
old_IFS=$IFS
IFS=$'\n'
line=($(cat ./.git/HEAD))
IFS=$old_IFS

myline=${line[0]}
tmp=${myline%%heads*}
#echo tmp is $tmp
tmp=$(( ${#tmp} + 1 ))
myline2=${myline:$tmp}
#echo myline2 is $myline2
branch=${myline2%%/*}
#echo branch is $branch
tmp2=$(( ${#branch} + 1 ))
#echo tmp2 is $tmp2
branch=${myline2:$tmp2}
#echo branch is $branch

#Get the SHA of the latest commit contained in the head file for the branch
old_IFS=$IFS
IFS=$'\n'
line=($(cat ./.git/refs/heads/$branch))
IFS=$old_IFS
commit=${line[0]}
#echo $commit

#ask for the remote to use
read -e -p "Remote name(defualt:origin): " remote
[ -z "${remote}" ] && remote=origin
echo Using $remote as remote


#perform the push to GitHub
git push $remote $branch
# echo Hey just did a push

#build the JSON object for the firebase update
start="-d {\""
key=CurrentCommit
colon=\"\:\"
value=$commit
end="\"}"
json=$start$key$colon$value$end

#Build the firebase path for the data update
pathstart="/git/"
pathdelimiter="/"
path=$pathstart$repo$pathdelimiter$branch
#echo $json
echo $path
#echo sending firebase data:update $json $path
firebase data:update $json $path
