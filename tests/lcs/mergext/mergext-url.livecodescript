﻿script "MergExtURL"
/*
Copyright (C) 2016 LiveCode Ltd.

This file is part of LiveCode.

LiveCode is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License v3 as published by the Free
Software Foundation.

LiveCode is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
for more details.

You should have received a copy of the GNU General Public License
along with LiveCode.  If not see <http://www.gnu.org/licenses/>.  */


on TestSetup
   -- Only run these tests on desktop platforms
   if the platform is not among the items of "MacOS,Linux" then
      return "SKIP Tests are not runnable on" && the platform
   end if
   
   local tBuilderUtilities
   put TestGetEngineRepositoryPath() & "/builder/builder_utilities.livecodescript" into tBuilderUtilities
   start using stack tBuilderUtilities
end TestSetup


on TestMergExtURL
   local tMergExtVersion
   put builderMergExtVersion() into tMergExtVersion
   
   local tTestVersion
   put tMergExtVersion into tTestVersion
   replace "-" with comma in tTestVersion
   put ",0,0,0,0" after tTestVersion
   convert tTestVersion to seconds
   TestAssert "mergext version is a date", the result is empty
   
   repeat for each word tEdition in "Community Indy Business"
      local tURL
      put builderMergExtUrl(tMergExtVersion,tEdition) into tURL
      
      get shell("curl  -s -o /dev/null -IL -w" && quote & "%{http_code}" & quote && tURL)
      TestAssert "mergext" && tEdition && "url is valid", it is 200
   end repeat
end TestMergExtURL


on TestTeardown
    delete stack "BuilderUtilities"
end TestTeardown
