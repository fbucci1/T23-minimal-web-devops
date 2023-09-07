INI_FILE=~/.t23/credentials
if test -f "$INI_FILE"; then
    while IFS=' = ' read key value
    do
        if [[ $key == \[*] ]]; then
            section=$key
        elif [[ $value ]] && [[ $section == '[default]' ]]; then
            if [[ $key == 'AWS_ACCOUNT_ID' ]]; then
                echo $value;
                exit 0;
            fi
        fi
    done < $INI_FILE
fi
exit 1;