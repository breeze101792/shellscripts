

###########################################################
## Path settings
###########################################################
for each_idx in $(seq 1 8)
do
    tmp_favorite_name="HSFM_FAV${each_idx}"

    tmp_ecd_name="HS_PATH_ECD_${each_idx}"

    if eval "test -d \"${!tmp_ecd_name}\""
    then
        eval "export ${tmp_favorite_name}=${!tmp_ecd_name}"
    fi
done

