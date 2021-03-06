" File: apexCommands.vim
" Author: Andrey Gavrikov 
" Version: 0.2
" Last Modified: 2014-02-17
" Copyright: Copyright (C) 2010-2014 Andrey Gavrikov
"            Permission is hereby granted to use and distribute this code,
"            with or without modifications, provided that this copyright
"            notice is copied with it. Like anything else that's free,
"            this plugin is provided *as is* and comes with no warranty of any
"            kind, either expressed or implied. In no event will the copyright
"            holder be liable for any damages resulting from the use of this
"            software.
"
" apexMappings.vim - vim-force.com commands mapping

" Part of vim-force.com plugin
"
" Only do this when not done yet for this buffer
if exists("g:loaded_apexCommands") || &compatible
  finish
endif
let g:loaded_apexCommands = 1


""""""""""""""""""""""""""""""""""""""""""""""""
" Apex commands 
""""""""""""""""""""""""""""""""""""""""""""""""
"staging
command! ApexStage :call apexStage#open(expand("%:p"))
command! ApexStageAdd :call apexStage#add(expand("%:p"))
command! ApexStageAddOpen :call apexStage#addOpen()
command! ApexStageRemove :call apexStage#remove(expand("%:p"))
command! ApexStageClear :call apexStage#clear(expand("%:p"))


" select file type, create it and switch buffer
command! ApexNewFile :call apexMetaXml#createFileAndSwitch(expand("%:p"))

" before refresh all changed files are backed up, so we can compare refreshed
" version with its pre-refresh condition
command! ApexCompareWithPreRefreshVersion :call apexUtil#compareWithPreRefreshVersion(apexOs#getBackupFolder())
command! ApexCompare :call ApexCompare()

" initialise Git repository and add files
command! ApexGitInit :call apexUtil#gitInit()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Apex Code - compare current file with its own in another Apex Project
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! DiffUnderEclipse :ApexCompare

""""""""""""""""""""""""""""""""""""""""""""""""
" tooling-force.com specific
""""""""""""""""""""""""""""""""""""""""""""""""
function! s:toolingJarSpecific()
	"
	" Deployment
	command! -bang -nargs=* -complete=customlist,apex#completeDeployParams ApexDeploy :call apexTooling#deploy('deploy', 'Modified', <bang>0, <f-args>)
	command! -bang -nargs=* -complete=customlist,apex#completeDeployParams ApexDeployAll :call apexTooling#deploy('deploy', 'All', <bang>0, <f-args>)
	command! -bang -nargs=* -complete=customlist,apex#completeDeployParams ApexDeployOpen :call apexTooling#deploy('deploy', 'Open', <bang>0, <f-args>)
	command! -bang -nargs=* -complete=customlist,apex#completeDeployParams ApexDeployStaged :call apexTooling#deploy('deploy', 'Staged', <bang>0, <f-args>)
	command! -bang -nargs=* -complete=customlist,apex#completeDeployParams ApexDeployOne :call apexTooling#deploy('deploy', 'One', <bang>0, <f-args>)
	" TODO
	"command! -nargs=* -complete=customlist,apex#completeDeployParams ApexDeployConfirm :call apexTooling#deploy('Confirm', <f-args>)

	command! -nargs=0 ApexRefreshProject :call apexTooling#refreshProject(expand("%:p"))

	command! ApexPrintChanged :call apexTooling#printChangedFiles(expand("%:p"))
	command! ApexPrintConflicts :call apexTooling#printConflicts(expand("%:p"))


	"Unit testing
	command! -bang -nargs=* -complete=customlist,apexTest#completeParams ApexTest :call apexTest#runTest('no-reportCoverage', <bang>0, <f-args>)
	command! -bar -bang -nargs=* -complete=customlist,apexTest#completeParams ApexTestWithCoverage :call apexTest#runTest('reportCoverage', <bang>0, <f-args>)
	command! -nargs=? -complete=buffer ApexTestCoverageShow :call apexCoverage#show(<q-args>)
	command! -nargs=0 ApexTestCoverageToggle :call apexCoverage#toggle(expand("%:p"))
	command! -nargs=0 ApexTestCoverageHideAll :call apexCoverage#hide()

	"delete Staged files from specified Org
	command! -nargs=* -complete=customlist,apexDelete#completeParams ApexRemoveStaged :call apexDelete#run(<f-args>)

	command! ApexRetrieve :call apexRetrieve#open(expand("%:p"))

	command! -nargs=? -complete=customlist,apex#listProjectNames -range=% ApexExecuteAnonymous <line1>,<line2>call apexTooling#executeAnonymous(expand("%:p"), <f-args>)
	command! -nargs=? -complete=customlist,apex#listProjectNames ApexExecuteAnonymousRepeat call apexTooling#executeAnonymousRepeat(expand("%:p"), <f-args>)

	" display last log
	command! ApexLog :call apexTooling#openLastLog()

	" open scratch buffer/file
	command! ApexScratch :call apexTooling#openScratchFile(expand("%:p"))

	" Tooling API commands
	command! -bang -nargs=* -complete=customlist,apex#completeDeployParams ApexSave :call apexTooling#deploy('save', 'Modified', <bang>0, <f-args>)
	
endfunction

" finally, define mappings
call s:toolingJarSpecific()
