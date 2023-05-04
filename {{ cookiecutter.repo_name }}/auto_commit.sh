source venv/bin/activate
#!/bin/bash
for i in {1..3};do pre-commit run --all-files;done
git checkout nir
git pull
git add .
read -p "Please enter commit message: " MESSAGE
git commit -m "$MESSAGE"
git push # push nir branch
git checkout development
git pull					# update local
git merge nir        # merge dev to stage
git push                    # push to dev branch
echo "Done merging to development"
to_production() {
    echo "merge to production branch"
    git checkout production
    git pull
    git merge staging
    git push
    git checkout nir
    }
# create merge request function
to_staging () {
    echo "merge to staging branch"
    git checkout staging
    git pull
    git merge development
    git push
    git checkout nir
    # ask user if merge to production
read -p "Do you wish to merge to production? " yn
    case $yn in
        [Yy]* ) to_production; exit;;
        [Nn]* ) git checkout nir; exit;;
        * ) echo "Please answer yes or no.";;
    esac
    }
# ask user if merge to stage
read -p "Do you wish to merge to stage? " yn
echo "you entered $yn"
    case $yn in
        [Yy]* ) to_staging; exit;;
        [Nn]* ) git checkout nir; exit;;
        * ) echo "Please answer yes or no.";;
    esac
git checkout nir
read -p "Press any key to continue..."
