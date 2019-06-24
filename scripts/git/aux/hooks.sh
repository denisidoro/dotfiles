#!/usr/bin/env bash

git::prompt_if_protected() {
   local current_branch="$1"
   local protected_branch="$2"

   if [ $protected_branch = $current_branch ]; then
      if ! feedback::confirmation "Are you sure you want to push to $protected_branch?" true; then
         exit 1
      fi
   fi
}

git::check_json() {
   local files="$1"

   for file in $(echo "$files" | grep -P '\.((json))$'); do
      set +e
      python -mjson.tool "$file" 2>&1 /dev/null
      local result=$?
      if [ $result -ne 0 ] ; then
         git::not_commited_msg
         log::error "Lint check of JSON object failed\n\tin $git_dir/$file"
         python -mjson.tool "$file"
         exit 1
      fi
      set -e
   done
}

git::check_edn() {
   local files="$1"

   for file in $(echo "$files" | grep -P '\.((edn))$'); do
      cat "$file" | dot clojure edn > /dev/null || {
         log::error "Lint check of EDN object failed\n\tin ${git_dir}/${file}"
         if ! feedback::confirmation "Are you sure you want to commit this file anyway?" false; then
            exit 2
         fi
      }
   done
}

git::match_content() {
   local files="$1"
   local name="$2"
   local pattern="$3"
   local stop="${4:-true}"

   for file in $(echo "$files"); do
      local res=$(cat "$file" | grep -E --line-number "$pattern");
      if [ -n "$res" ]; then
         $stop && { not_commited_msg; }
         log::error "$file matched the \"$name\" blacklist content regex:"
         echo "$res"
         if $stop; then
            if ! feedback::confirmation "Are you sure you want to commit anyway?" false; then
               exit 3
            fi
         else
            git::commited_anyway_msg
         fi
      fi
   done
}

git::match_filename() {
   local files="$1"
   local name="$2"
   local pattern="$3"
   local stop="${4:-true}"

   for file in $(echo "$files"); do
      local res=$(echo "$file" | grep -E "$pattern");
      if [ -n "$res" ]; then
         $stop && { not_commited_msg; }
         log::error "$file matched the \"$name\" blacklist filename regex:"

         if $stop; then
            if ! feedback::confirmation "Are you sure you want to commit anyway?" false; then
               exit 4
            fi
         else
            git::commited_anyway_msg
         fi
      fi
   done
}

git::check_aws() {
   local files="$1"

   git::match_content "$files" "AWS key ID" "[^A-Z0-9][A-Z0-9]{20}[^A-Z0-9]" true
   git::match_content "$files" "AWS key" "[^A-Za-z0-9/+=][A-Za-z0-9/+=]{40}[^A-Za-z0-9/+=]" true
}

git::check_conflict() {
   local files="$1"

   for file in $(echo "$files"); do
      local res=$(echo "$file" | egrep '^[><=]{7}( |$)' -H -I --line-number && echo 0 || echo 1)
      if [ $res == 0 ]; then
         log::error "$file still has unresolved conflicts"
         exit 5
      fi
   done
}

git::not_commited_msg() {
   log::error "Your changes were not commited"
}

git::commited_anyway_msg() {
   log::warning "Your changes were commited anyway"
}
