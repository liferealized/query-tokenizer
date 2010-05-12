<cfcomponent output="false">

	<cfscript>
		variables.class = {};
		variables.class.RESQLToken = "\(|\)|'|""|`|\*|,|<>|<=|<|>=|>|=|[+]|!=";
		variables.class.RESQLTerminal = variables.class.RESQLToken & "|;|[[:space:]]+";
	</cfscript>
	
	<cffunction name="tokenizeSql" returntype="any" output="false" access="public">
		<cfargument name="sql" type="string" required="true" />
		<cfscript>
			var loc = { 
				  result = []
			};
			loc.sql = REReplace(Trim(arguments.sql), "([[:space:]]*,)", ",", "all"); // remove all spaces in front of commas
			
			loc.part = $matchSqlPart(string=loc.sql);
			
			while (Len(loc.part))
			{
				if (loc.part == "'")
				{
					loc.part = $singleQuoteString(loc.sql);
					ArrayAppend(loc.result, loc.part);
				}
				else if (loc.part == "`")
				{
					loc.part = $backQuoteString(loc.sql);
					ArrayAppend(loc.result, loc.part);
				}
				else if (loc.part == '"')
				{
					loc.part = $doubleQuoteString(loc.sql);
					ArrayAppend(loc.result, loc.part);
				}
				else
				{
					ArrayAppend(loc.result, loc.part);
				}
			
				loc.rightLen = Len(loc.sql) - Len(loc.part);
				if (loc.rightLen gt 0)
					loc.sql = Trim(Right(loc.sql, loc.rightLen));
				else
					loc.sql = "";
					
				loc.part = $matchSqlPart(string=loc.sql, length=ArrayLen(loc.result));
				
				if (!Len(loc.part))
					ArrayAppend(loc.result, loc.sql);
			}
		</cfscript>
		<cfreturn loc.result />
	</cffunction>
	
	<cffunction name="$matchSqlPart" output="false" access="public" returntype="string">
		<cfargument name="string" type="string" required="true" />
		<cfargument name="length" type="numeric" required="false" default="0" />
		<cfscript>
			var loc = { tokenArray = [] };
			
			loc.tokenArray = REMatch("^(#variables.class.RESQLToken#)", arguments.string);
			if (ArrayLen(loc.tokenArray)) return loc.tokenArray[1];
			
			loc.tokenArray = REMatch("^(#variables.class.RESQLToken#)(#variables.class.RESQLTerminal#)", arguments.string);
			if (ArrayLen(loc.tokenArray)) return loc.tokenArray[1];
			
			loc.tokenArray = REMatch("^(#variables.class.RESQLToken#).", arguments.string);
			if (ArrayLen(loc.tokenArray)) return loc.tokenArray[1];
			
			loc.tokenArray = REMatch("^([a-zA-Z0-9\-_\.]+?)(#variables.class.RESQLTerminal#)", arguments.string);
			if (ArrayLen(loc.tokenArray)) return loc.tokenArray[1];
		</cfscript>
		<cfreturn "" />
	</cffunction>
	
	<cffunction name="$singleQuoteString" output="false" access="public" returntype="string">
		<cfargument name="string" type="string" required="true" />
		<cfscript>
			var loc = {};
			loc.matches = REMatch("^'(.*?([']{2}|(\\'))?)+'.", arguments.string);
		</cfscript>
		<cfreturn loc.matches[1] />
	</cffunction>
	
	<cffunction name="$backQuoteString" output="false" access="public" returntype="string">
		<cfargument name="string" type="string" required="true" />
		<cfscript>
			var loc = {};
			loc.matches = REMatch("^(`.*?`)\.?(`.*?`)?.", arguments.string);
		</cfscript>
		<cfreturn loc.matches[1] />
	</cffunction>
	
	<cffunction name="$doubleQuoteString" output="false" access="public" returntype="string">
		<cfargument name="string" type="string" required="true" />
		<cfscript>
			var loc = {};
			loc.matches = REMatch("^""(.*?)"".", arguments.string);
		</cfscript>
		<cfreturn loc.matches[1] />
	</cffunction>
	
	<cffunction name="$dump" returntype="void" access="public" output="true">
		<cfargument name="var" type="any" required="true">
		<cfargument name="abort" type="boolean" required="false" default="true">
		<cfdump var="#arguments.var#">
		<cfif arguments.abort>
			<cfabort>
		</cfif>
	</cffunction>
	
</cfcomponent>