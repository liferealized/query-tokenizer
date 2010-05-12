<cfsavecontent variable="sql">
SELECT `contents`.`id`
	, contents.title
	, templates.title AS templatetitle
	, `url`
	, contents.delayInDays
	, contents.delayRendering
	, contents.tagList
	, contents.standAlone
	, pagecontents.region
	, pagecontents.sortOrder,blocks.id AS blockid,blocks.label,blocks.displayOn,blocks.configurationProperties,blocks.content,blocks.prepend,blocks.append,blocks.saveAsVariable,blocks.displayCfmCode,blocks.editModel,blocks.editMethod,blocks.dataModel,blocks.dataMethod,blocks.cacheTemplate 
FROM contents 
	LEFT OUTER JOIN pagecontents ON contents.id = pagecontents.contentId 
	INNER JOIN blocks ON contents.id = blocks.contentId 
	LEFT OUTER JOIN groupables ON contents.id = groupables.objectId 
	INNER JOIN templates ON contents.templateId = templates.id 
WHERE pagecontents.pageId = 395 
AND contents.accountId <> 47
AND contents.isLive != 1
AND contents.isLive LIKE "adf%"
AND contents.id IN (1,2,3,4,5,6,7,8,9)
AND contents.lastname = 'O'' 	Malley\'s  '
AND ('2010-05-11' >= ADDDATE(contents.startDate, INTERVAL -4 HOUR) OR contents.startDate IS NULL) 
AND ('2010-05-11' <= ADDDATE(contents.endDate, INTERVAL -4 HOUR) OR contents.endDate IS NULL) 
AND (groupables.groupId IS NULL OR groupables.groupId IN (731)) AND CASE WHEN groupables.groupId = 731 THEN contents.delayInDays <= 40307 ELSE contents.delayInDays <= 40307 END 
GROUP BY 
	contents.id,
	contents.title,
	templates.title,
	contents.url,
	contents.delayInDays,
	contents.delayRendering,
	contents.tagList,
	contents.standAlone,
	pagecontents.region,
	pagecontents.sortOrder,
	blocks.id,
	blocks.label,
	blocks.displayOn,
	blocks.configurationProperties,
	blocks.content,
	blocks.prepend,
	blocks.append,
	blocks.saveAsVariable,
	blocks.displayCfmCode,
	blocks.editModel,
	blocks.editMethod,
	blocks.dataModel,blocks.dataMethod,blocks.cacheTemplate 
ORDER BY pagecontents.sortOrder ASC,blocks.sortOrder ASC 
</cfsavecontent>

<cfset qTok = CreateObject("component", "QueryTokenizer") />
<cfset array = qTok.tokenizeSql(sql) />
<cfdump var="#array#" />