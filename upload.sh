echo ">> Third-party cookbooks:"
berks install
berks upload
echo ">> PoC cookbooks:"
knife cookbook upload -a
echo ">> PoC roles:"
knife role from file roles/*.rb
#echo ">> PoC data bags:"
#knife data bag from file -a