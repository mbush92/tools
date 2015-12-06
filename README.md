# Tools
This repository contains various tools that I have created to help me write or use code better

## git_push_firebase.sh
This tool when installed will allow you to simultaneously perform a push into your git repository by specifying the correct name of the remote you want to push into and the branch you are currently checked out in.  If you are logged into firebase it will then update a node /git/$repositoryname/$branch with a child called {"CurrentCommit":$commitSHA}
