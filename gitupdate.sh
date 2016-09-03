#!/bin/bash
git add .
date >> docs/change.txt
echo --- Code Commit ------ $1 $2 $3 $4 $5 $6 $7 $8 $9 >> docs/change.txt
echo '#!/bin/bash' > gitcommit.sh
echo echo running commit >> gitcommit.sh
echo git commit -m \'$1 $2 $3 $4 $5 $6 $7 $8 $9\' >> gitcommit.sh
chmod u+rwx gitcommit.sh
./gitcommit.sh
rm gitcommit.sh
git push origin master

