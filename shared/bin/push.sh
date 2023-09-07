echo -- Status
pwd

git status -s

TMP=$(git status|grep -o "nothing to commit") 
if [ "$TMP" == "nothing to commit" ]; then 
    echo "Nothing to commit"; 
    exit 0; 
fi

read -p "Press enter to continue"

echo -- Adding
git add .

echo -- Committing
git commit -q -m "updated"

echo -- Pushing
git push -q

