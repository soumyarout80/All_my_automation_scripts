
#!/bin/sh



branch=$1

package=${2:-dk-w3-website}

env=nm

timestamp=$(date +%s)

usage="Usage : promote.sh <branch_name> [package]"

if [ -z ${branch} ];then

  echo ${usage}

  exit 1

fi

echo "Building branch $branch for package $package"





if [ "${env}" == "nm" -o "${env}" == "stagech" -o "${env}" == "qa" -o "${env}" == "next" ]; then

    echo "Stashing changes on current branch"

    git stash save "git_push saved changes"

    echo "Checkout $branch"

    git checkout ${branch}



    echo "Pull github & corp - ${branch}"

    git pull github ${branch}

    git pull origin ${branch}



    echo "Commit to github & corp - ${branch}"

    git push github ${branch}

    git push origin ${branch}



    echo "Create tags"

    git tag -m "Promoting ${package} to ${env}" release/${package}/${env}-${timestamp}-nodeploy;

    echo "Tagged with timestamp : $timestamp";

    echo "New tag for ${env} : 1.$timestamp-01${env}" | mail -s "[Deployment] Tag : ${env}" lego-dev-ops@project.com



    echo "Pushing tags to both repositories"

    git push github --tags

    git push origin --tags

    echo "Done. Go back to your old branch and unstash changes to continue work"

else

    echo ${usage}

    exit 1

fi
