if (do shell script "defaults read com.apple.finder CreateDesktop") is equal to "true" then
    do shell script "defaults write com.apple.finder CreateDesktop false"
else
    do shell script "defaults write com.apple.finder CreateDesktop true"
end if

do shell script "killall Finder"

return 1
