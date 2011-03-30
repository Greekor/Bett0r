<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE pinnacle_line_feed [
<!ELEMENT PinnacleFeedTime (#PCDATA)>
<!ELEMENT lastContest (#PCDATA)>
<!ELEMENT lastGame (#PCDATA)>
<!ELEMENT contest_maximum (#PCDATA)>
<!ELEMENT contestantnum (#PCDATA)>
<!ELEMENT description (#PCDATA)>
<!ELEMENT event (event_datetimeGMT, gamenumber, sporttype, league,IsLive?, contest_maximum?, description?, (participants |  periods | total)+)>
<!ELEMENT event_datetimeGMT (#PCDATA)>
<!ELEMENT gamenumber (#PCDATA)>
<!ELEMENT league (#PCDATA)>
<!ELEMENT odds (moneyline_value, to_base?)>
<!ELEMENT over_adjust (#PCDATA)>
<!ELEMENT participants (participant*)>
<!ELEMENT participant (participant_name, contestantnum, rotnum, visiting_home_draw?, odds?, pitcher?)>
<!ELEMENT participant_name (#PCDATA)>
<!ELEMENT periods (period*)>
<!ELEMENT period (period_number, period_description, periodcutoff_datetimeGMT, period_status, period_update, spread_maximum?, moneyline_maximum?, total_maximum?, moneyline?, spread?, total?)>
<!ELEMENT period_number (#PCDATA)>
<!ELEMENT period_description (#PCDATA)>
<!ELEMENT period_status (#PCDATA)>
<!ELEMENT period_update (#PCDATA)>
<!ELEMENT periodcutoff_datetimeGMT (#PCDATA)>
<!ELEMENT pinnacle_line_feed (PinnacleFeedTime, lastContest, lastGame, events)>
<!ELEMENT events (event*)>
<!ELEMENT pitcher (#PCDATA)>
<!ELEMENT rotnum (#PCDATA)>
<!ELEMENT sporttype (#PCDATA)>
<!ELEMENT moneyline (moneyline_visiting, moneyline_home, moneyline_draw?)>
<!ELEMENT moneyline_value (#PCDATA)>
<!ELEMENT moneyline_visiting (#PCDATA)>
<!ELEMENT moneyline_home (#PCDATA)>
<!ELEMENT moneyline_draw (#PCDATA)>
<!ELEMENT moneyline_maximum (#PCDATA)>
<!ELEMENT spread (spread_visiting, spread_adjust_visiting, spread_home, spread_adjust_home)>
<!ELEMENT spread_adjust_home (#PCDATA)>
<!ELEMENT spread_adjust_visiting (#PCDATA)>
<!ELEMENT spread_home (#PCDATA)>
<!ELEMENT spread_maximum (#PCDATA)>
<!ELEMENT spread_visiting (#PCDATA)>
<!ELEMENT to_base (#PCDATA)>
<!ELEMENT total (total_points, over_adjust?, under_adjust?, units?)>
<!ELEMENT total_maximum (#PCDATA)>
<!ELEMENT total_points (#PCDATA)>
<!ELEMENT under_adjust (#PCDATA)>
<!ELEMENT units (#PCDATA)>
<!ELEMENT IsLive (#PCDATA)>
<!ELEMENT visiting_home_draw (#PCDATA)>
]>


<!--
IMPORTANT CHANGE - June, 2008

Some xml consumers have reported incorrect Soccer Total (Asian Handicaps) and others have reported missed updates.

A release performed on June 24th, 2008 addresses the incorrect odds reported for Soccer Total (Asian Handicaps).

As for the missed updates, due to the complexity of our platform, a small schema change along with a new way to make incremental calls has been developed.

It is important to note that the previous functionality, using the last parameter, has been grandfathered so that current users do not need to worry about this upgrade breaking their parsing software.  At some point, we will remove this functionality, so please upgrade your software in a timely fashion.

The feed will now contain two new elements, lastGame and lastContest.

If you are interested in games only you can use the value of the element lastGame to make an incremental call.

For example.
Get the static file - http://xml.pinnaclesports.com/pinnaclefeed.asp
Make an incremental call to get up to date - http://xml.pinnaclesports.com/pinaclefeed.asp?lastGame=42145789 (the value for lastGame is found in the static file and subsequent incremental updates)

If you are also interested in contests, simply add the parameter lastContest to the query string with the value found in the static file.

For example.
Get the static file - http://xml.pinnaclesports.com/pinnaclefeed.asp
Make an incremental call to get up to date - http://xml.pinnclesports.com/pinnaclefeed.asp?lastGame=42145789&lastContest=4678

You can also mix and match sportType, sportSubType with lastGame if you are only interested in one sport (see examples way below, mixing sporttype, sportSubType and last).

Attention:  lastContest does not work without lastGame.

Attention:  last supercedes the usage of either lastGame or lastContest.  If you issue both last and either of lastGame or lastContest in the same call, only last will be used.

Warning:  The usage of SportType and SportSubtype is being abused.  The intent is to only be used by those who are only interested in one or two specific leagues.  We have observed, from the same IP, calls to all individual soccer leagues (more than 800 of them) in rapid succession.  This is a situation that calls for getting the static file, and then getting incremental updates without a sportType/sportSubtype being specified.  This type of abuse puts a lot of stress on our backend servers.  We are monitoring and will limit access to our systems from IP exhibiting this type of behavior.




IMPORTANT CHANGE

Pinnacle Sports has released a new and updated version of our live lines feed. A working knowledge of XML is required for integration purposes. Pinnacle Sports regrets that it is unable to provide additional programming support.

USAGE:

-  Get the file produced by http://xml.pinnaclesports.com/pinnacleFeed.asp. The server will produce a static file which is updated every 10 minutes.
-  Make an incremental call to the same URL to receive the latest updates since the static file was produced by using the PinnacleFeedTime found in the previous call (example http://xml.pinnaclesports.com/pinnacleFeed.asp?last=1196199051920)
-  The PinnacleFeedTime is a critical part of this system and represents the number of milliseconds since the epoch. To compensate for the various latencies between the time at which the PinnacleFeedTime value was generated and the production of the static file, it is perfectly acceptable to deduct a certain number of seconds (in milliseconds) from this value.  Please note however, that this can result in duplicate updates which you will need to be able to resolve.



PARAMETERS:

last: This is used to receive incremental updates using the value of PinncelFeedTime. Always use the value of PinnacleFeedTime found in the previous evocation of the xml feed. A PinnacleFeedTime older than 60 minutes, in the absence of the sportType parameter, will have no effect. If you do not include the PinnacleFeedTime, you will receive the same static file as if you had issued a call without it (unless the sporttype parameter was used, see next section).

sporttype: (maximum size of 20 characters) This can be used to restrict the feed to a particular sport (examples of a valid sporttype are Baseball, Football (for American Football), Handball, Hockey, Soccer etc.). With the exception of soccer, providing a sporttype parameter will result in a dynamic feed with lines current at the time of the call. Due to the number of individual leagues in soccer, please refer to the Standard usage example below to receive up to date lines for soccer. A list of valid "sports" can be found at http://xml.pinnaclesports.com/leagues.asp.

sportsubtype:  (maximum size of 12 characters) This can be used to restrict the feed to a chosen League only for a particular sport. When using a specific sportsubtype, you must include a valid sporttype to identify the sport and league. For example, NCAA could refer to either Basketball or Football in American college sports. Refer to http://xml.pinnaclesports.com/leagues.asp for the complete list of leagues that are currently available together with the matching 12 character abbreviation.

contest: This can be used to prevent the display of contests using the following name/value pair in the query string: contest=no.



EXAMPLES:

Standard usage
1. Get the complete feed with http://xml.pinnaclesports.com/pinnacleFeed.asp
2. Make an incremental call to receive the latest changes with http://xml.pinnaclesports.com/pinnacleFeed.asp?last=1196336347638
3. Make a second incremental call 60 seconds later to receive the latest changes with http://xml.pinnaclesports.com/pinnacleFeed.asp?last=1196336407638
4. In this example it was assumed that the complete feed included a value of 1196336347638 for the PinnacleFeedTime. Please ensure to always use the value present in the feed obtained in the previous call.


Interested in Hockey only
1.  Get the full list of hockey games with http://xml.pinnaclesports.com/pinnacleFeed.asp?sportType=Hockey&contest=no
2.  Make an incremental call to receive the latest changes in Hockey with ttp://xml.pinnaclesports.com/pinnacleFeed.asp?sportType=Hockey&last=1196336347639&contest=no
3.  Make another incremental call 60 seconds later to receive the latest changes with http://xml.pinnaclesports.com/pinnacleFeed.asp?sportType=Hockey&last=1196336407639&contest=no
4.  In this example it was assumed that the complete feed included a value of 1196336347639 for the PinnacleFeedTime. Please ensure to always use the value present in the feed obtained in the previous call.

Interested in Soccer only
1. Get the complete feed with http://xml.pinnaclesports.com/pinnacleFeed.asp
2. Make an incremental call to receive the latest changes with http://xml.pinnaclesports.com/pinnacleFeed.asp?sportType=Soccer&last=1196336347640
3. Make another incremental call 60 seconds later to receive the latest changes with http://xml.pinnaclesports.com/pinnacleFeed.asp?sportType=Hockey&last=1196336407640&contest=no
4. In this example it was assumed that the complete feed included a value of 1196336347640 for the PinnacleFeedTime. Please ensure to always use the value present in the feed obtained in the previous call.

IMPORTANT NOTICE:

Please refrain from using a very high frequency of calls to the xml feed. Pinnacle Sports reserves the right to monitor usage of the XML feed and block the IP address range of any user that abuses this service. 1 call per minute is considered an acceptable usage of the feed.

UPDATE September, 2010:

There is a new element ‘IsLive’, it indicates whether the event is dealt live or not. All live soccer spread lines are in the 'full game' format. Please note that on the website the spread odds are in the 'rest of the game' format
-->
<pinnacle_line_feed>


<PinnacleFeedTime>1301510124355</PinnacleFeedTime>
<lastContest>6461449</lastContest>
<lastGame>65049840</lastGame>
<events>
<event>
	<event_datetimeGMT>2011-03-30 19:45</event_datetimeGMT>
	<gamenumber>198632412</gamenumber>
	<sporttype>Baseball</sporttype>
	<league>MLB</league>
	<IsLive>No</IsLive>
	<participants>
		<participant>
			<participant_name>Oakland Athletics</participant_name>
			<contestantnum>979</contestantnum>
			<rotnum>979</rotnum>
			<visiting_home_draw>Visiting</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>San Fransisco Giants</participant_name>
			<contestantnum>980</contestantnum>
			<rotnum>980</rotnum>
			<visiting_home_draw>Home</visiting_home_draw>
		</participant>
	</participants>
	<periods>
		<period>
			<period_number>0</period_number>
			<period_description>Game</period_description>
			<periodcutoff_datetimeGMT>2011-03-30 19:45</periodcutoff_datetimeGMT>
			<period_status>I</period_status>
			<period_update>open</period_update>
			<spread_maximum>20000</spread_maximum>
			<moneyline_maximum>2000</moneyline_maximum>
			<total_maximum>10000</total_maximum>
			<moneyline>
				<moneyline_visiting>118</moneyline_visiting>
				<moneyline_home>-125</moneyline_home>
			</moneyline>
		</period>
	</periods>
</event>
<event>
	<event_datetimeGMT>2011-03-31 17:00</event_datetimeGMT>
	<gamenumber>198635267</gamenumber>
	<sporttype>Basketball</sporttype>
	<league>Austria OBL</league>
	<IsLive>No</IsLive>
	<participants>
		<participant>
			<participant_name>Arkadia Traiskirchen Lions</participant_name>
			<contestantnum>1351</contestantnum>
			<rotnum>1351</rotnum>
			<visiting_home_draw>Home</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>Xion Dukes Klosterneuburg</participant_name>
			<contestantnum>1352</contestantnum>
			<rotnum>1352</rotnum>
			<visiting_home_draw>Visiting</visiting_home_draw>
		</participant>
	</participants>
	<periods>
		<period>
			<period_number>0</period_number>
			<period_description>Game</period_description>
			<periodcutoff_datetimeGMT>2011-03-31 17:00</periodcutoff_datetimeGMT>
			<period_status>I</period_status>
			<period_update>open</period_update>
			<spread_maximum>100</spread_maximum>
			<moneyline_maximum>100</moneyline_maximum>
			<total_maximum>100</total_maximum>
			<moneyline>
				<moneyline_visiting>252</moneyline_visiting>
				<moneyline_home>-271</moneyline_home>
			</moneyline>
			<spread>
				<spread_visiting>6.5</spread_visiting>
				<spread_adjust_visiting>-104</spread_adjust_visiting>
				<spread_home>-6.5</spread_home>
				<spread_adjust_home>-102</spread_adjust_home>
			</spread>
			<total>
				<total_points>154</total_points>
				<over_adjust>-103</over_adjust>
				<under_adjust>-103</under_adjust>
			</total>
		</period>
	</periods>
</event>
<event>
	<event_datetimeGMT>2011-03-31 17:00</event_datetimeGMT>
	<gamenumber>198566869</gamenumber>
	<sporttype>Basketball</sporttype>
	<league>Austria OBL</league>
	<IsLive>No</IsLive>
	<participants>
		<participant>
			<participant_name>BasketClubs Vienna</participant_name>
			<contestantnum>1353</contestantnum>
			<rotnum>1353</rotnum>
			<visiting_home_draw>Home</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>UBSC Graz</participant_name>
			<contestantnum>1354</contestantnum>
			<rotnum>1354</rotnum>
			<visiting_home_draw>Visiting</visiting_home_draw>
		</participant>
	</participants>
	<periods>
		<period>
			<period_number>0</period_number>
			<period_description>Game</period_description>
			<periodcutoff_datetimeGMT>2011-03-31 17:00</periodcutoff_datetimeGMT>
			<period_status>I</period_status>
			<period_update>open</period_update>
			<spread_maximum>100</spread_maximum>
			<moneyline_maximum>100</moneyline_maximum>
			<total_maximum>100</total_maximum>
			<moneyline>
				<moneyline_visiting>122</moneyline_visiting>
				<moneyline_home>-130</moneyline_home>
			</moneyline>
			<spread>
				<spread_visiting>2</spread_visiting>
				<spread_adjust_visiting>-101</spread_adjust_visiting>
				<spread_home>-2</spread_home>
				<spread_adjust_home>-105</spread_adjust_home>
			</spread>
			<total>
				<total_points>153</total_points>
				<over_adjust>-103</over_adjust>
				<under_adjust>-103</under_adjust>
			</total>
		</period>
	</periods>
</event>
<event>
	<event_datetimeGMT>2011-03-31 16:45</event_datetimeGMT>
	<gamenumber>198635291</gamenumber>
	<sporttype>Basketball</sporttype>
	<league>Austria OBL</league>
	<IsLive>No</IsLive>
	<participants>
		<participant>
			<participant_name>Oberwart Gunners</participant_name>
			<contestantnum>1355</contestantnum>
			<rotnum>1355</rotnum>
			<visiting_home_draw>Home</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>Kapfenberg Bulls</participant_name>
			<contestantnum>1356</contestantnum>
			<rotnum>1356</rotnum>
			<visiting_home_draw>Visiting</visiting_home_draw>
		</participant>
	</participants>
	<periods>
		<period>
			<period_number>0</period_number>
			<period_description>Game</period_description>
			<periodcutoff_datetimeGMT>2011-03-31 16:45</periodcutoff_datetimeGMT>
			<period_status>I</period_status>
			<period_update>open</period_update>
			<spread_maximum>100</spread_maximum>
			<moneyline_maximum>100</moneyline_maximum>
			<total_maximum>100</total_maximum>
			<moneyline>
				<moneyline_visiting>287</moneyline_visiting>
				<moneyline_home>-311</moneyline_home>
			</moneyline>
			<spread>
				<spread_visiting>7.5</spread_visiting>
				<spread_adjust_visiting>-103</spread_adjust_visiting>
				<spread_home>-7.5</spread_home>
				<spread_adjust_home>-103</spread_adjust_home>
			</spread>
			<total>
				<total_points>142</total_points>
				<over_adjust>-103</over_adjust>
				<under_adjust>-103</under_adjust>
			</total>
		</period>
	</periods>
</event>
<event>
	<event_datetimeGMT>2011-03-31 17:00</event_datetimeGMT>
	<gamenumber>198566907</gamenumber>
	<sporttype>Basketball</sporttype>
	<league>Austria OBL</league>
	<IsLive>No</IsLive>
	<participants>
		<participant>
			<participant_name>ökoStadt Güssing Knights</participant_name>
			<contestantnum>1357</contestantnum>
			<rotnum>1357</rotnum>
			<visiting_home_draw>Home</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>UBC St. Pölten</participant_name>
			<contestantnum>1358</contestantnum>
			<rotnum>1358</rotnum>
			<visiting_home_draw>Visiting</visiting_home_draw>
		</participant>
	</participants>
	<periods>
		<period>
			<period_number>0</period_number>
			<period_description>Game</period_description>
			<periodcutoff_datetimeGMT>2011-03-31 17:00</periodcutoff_datetimeGMT>
			<period_status>I</period_status>
			<period_update>open</period_update>
			<spread_maximum>100</spread_maximum>
			<moneyline_maximum>100</moneyline_maximum>
			<total_maximum>100</total_maximum>
			<moneyline>
				<moneyline_visiting>141</moneyline_visiting>
				<moneyline_home>-150</moneyline_home>
			</moneyline>
			<spread>
				<spread_visiting>3</spread_visiting>
				<spread_adjust_visiting>-103</spread_adjust_visiting>
				<spread_home>-3</spread_home>
				<spread_adjust_home>-103</spread_adjust_home>
			</spread>
			<total>
				<total_points>151.5</total_points>
				<over_adjust>-103</over_adjust>
				<under_adjust>-103</under_adjust>
			</total>
		</period>
	</periods>
</event>
<event>
	<event_datetimeGMT>2011-03-30 23:05</event_datetimeGMT>
	<gamenumber>198632362</gamenumber>
	<sporttype>Basketball</sporttype>
	<league>NBA</league>
	<IsLive>No</IsLive>
	<participants>
		<participant>
			<participant_name>Orlando Magic</participant_name>
			<contestantnum>511</contestantnum>
			<rotnum>511</rotnum>
			<visiting_home_draw>Visiting</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>Atlanta Hawks</participant_name>
			<contestantnum>512</contestantnum>
			<rotnum>512</rotnum>
			<visiting_home_draw>Home</visiting_home_draw>
		</participant>
	</participants>
	<periods>
		<period>
			<period_number>0</period_number>
			<period_description>Game</period_description>
			<periodcutoff_datetimeGMT>2011-03-30 23:05</periodcutoff_datetimeGMT>
			<period_status>O</period_status>
			<period_update>open</period_update>
			<spread_maximum>20000</spread_maximum>
			<moneyline_maximum>10000</moneyline_maximum>
			<total_maximum>10000</total_maximum>
			<moneyline>
				<moneyline_visiting>-144</moneyline_visiting>
				<moneyline_home>130</moneyline_home>
			</moneyline>
			<spread>
				<spread_visiting>-2.5</spread_visiting>
				<spread_adjust_visiting>-110</spread_adjust_visiting>
				<spread_home>2.5</spread_home>
				<spread_adjust_home>100</spread_adjust_home>
			</spread>
			<total>
				<total_points>187.5</total_points>
				<over_adjust>-107</over_adjust>
				<under_adjust>-103</under_adjust>
			</total>
		</period>
	</periods>
</event>
<event>
	<event_datetimeGMT>2011-03-31 00:05</event_datetimeGMT>
	<gamenumber>198632364</gamenumber>
	<sporttype>Basketball</sporttype>
	<league>NBA</league>
	<IsLive>No</IsLive>
	<participants>
		<participant>
			<participant_name>Chicago Bulls</participant_name>
			<contestantnum>515</contestantnum>
			<rotnum>515</rotnum>
			<visiting_home_draw>Visiting</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>Minnesota Timberwolves</participant_name>
			<contestantnum>516</contestantnum>
			<rotnum>516</rotnum>
			<visiting_home_draw>Home</visiting_home_draw>
		</participant>
	</participants>
	<periods>
		<period>
			<period_number>0</period_number>
			<period_description>Game</period_description>
			<periodcutoff_datetimeGMT>2011-03-31 00:05</periodcutoff_datetimeGMT>
			<period_status>O</period_status>
			<period_update>open</period_update>
			<spread_maximum>20000</spread_maximum>
			<moneyline_maximum>10000</moneyline_maximum>
			<total_maximum>10000</total_maximum>
			<moneyline>
				<moneyline_visiting>-525</moneyline_visiting>
				<moneyline_home>442</moneyline_home>
			</moneyline>
			<spread>
				<spread_visiting>-9</spread_visiting>
				<spread_adjust_visiting>-110</spread_adjust_visiting>
				<spread_home>9</spread_home>
				<spread_adjust_home>100</spread_adjust_home>
			</spread>
			<total>
				<total_points>197</total_points>
				<over_adjust>-106</over_adjust>
				<under_adjust>-104</under_adjust>
			</total>
		</period>
	</periods>
</event>
<event>
	<event_datetimeGMT>2011-03-31 23:00</event_datetimeGMT>
	<gamenumber>198707926</gamenumber>
	<sporttype>Basketball</sporttype>
	<league>NCAA</league>
	<IsLive>No</IsLive>
	<participants>
		<participant>
			<participant_name>Wichita State</participant_name>
			<contestantnum>705</contestantnum>
			<rotnum>705</rotnum>
			<visiting_home_draw>Visiting</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>Alabama</participant_name>
			<contestantnum>706</contestantnum>
			<rotnum>706</rotnum>
			<visiting_home_draw>Home</visiting_home_draw>
		</participant>
	</participants>
	<periods>
		<period>
			<period_number>0</period_number>
			<period_description>Game</period_description>
			<periodcutoff_datetimeGMT>2011-03-31 23:00</periodcutoff_datetimeGMT>
			<period_status>I</period_status>
			<period_update>open</period_update>
			<spread_maximum>5000</spread_maximum>
			<moneyline_maximum>3000</moneyline_maximum>
			<total_maximum>1000</total_maximum>
			<moneyline>
				<moneyline_visiting>-130</moneyline_visiting>
				<moneyline_home>118</moneyline_home>
			</moneyline>
			<spread>
				<spread_visiting>-1.5</spread_visiting>
				<spread_adjust_visiting>-113</spread_adjust_visiting>
				<spread_home>1.5</spread_home>
				<spread_adjust_home>102</spread_adjust_home>
			</spread>
			<total>
				<total_points>129.5</total_points>
				<over_adjust>-108</over_adjust>
				<under_adjust>-108</under_adjust>
			</total>
		</period>
	</periods>
</event>
<event>
	<event_datetimeGMT>2011-03-30 23:05</event_datetimeGMT>
	<gamenumber>198632452</gamenumber>
	<sporttype>Hockey</sporttype>
	<league>NHL OT Incl</league>
	<IsLive>No</IsLive>
	<participants>
		<participant>
			<participant_name>New York Rangers</participant_name>
			<contestantnum>3</contestantnum>
			<rotnum>3</rotnum>
			<visiting_home_draw>Visiting</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>Buffalo Sabres</participant_name>
			<contestantnum>4</contestantnum>
			<rotnum>4</rotnum>
			<visiting_home_draw>Home</visiting_home_draw>
		</participant>
	</participants>
	<periods>
		<period>
			<period_number>0</period_number>
			<period_description>Game</period_description>
			<periodcutoff_datetimeGMT>2011-03-30 23:08</periodcutoff_datetimeGMT>
			<period_status>O</period_status>
			<period_update>open</period_update>
			<spread_maximum>3000</spread_maximum>
			<moneyline_maximum>6000</moneyline_maximum>
			<total_maximum>3000</total_maximum>
			<moneyline>
				<moneyline_visiting>-106</moneyline_visiting>
				<moneyline_home>-102</moneyline_home>
			</moneyline>
			<spread>
				<spread_visiting>1.5</spread_visiting>
				<spread_adjust_visiting>-313</spread_adjust_visiting>
				<spread_home>-1.5</spread_home>
				<spread_adjust_home>282</spread_adjust_home>
			</spread>
			<total>
				<total_points>5</total_points>
				<over_adjust>-127</over_adjust>
				<under_adjust>117</under_adjust>
			</total>
		</period>
		<period>
			<period_number>1</period_number>
			<period_description>1st Period</period_description>
			<periodcutoff_datetimeGMT>2011-03-30 23:08</periodcutoff_datetimeGMT>
			<period_status>O</period_status>
			<period_update>open</period_update>
			<spread_maximum>1000</spread_maximum>
			<moneyline_maximum>1000</moneyline_maximum>
			<total_maximum>1000</total_maximum>
			<moneyline>
				<moneyline_visiting>-104</moneyline_visiting>
				<moneyline_home>-104</moneyline_home>
			</moneyline>
			<spread>
				<spread_visiting>0.5</spread_visiting>
				<spread_adjust_visiting>-203</spread_adjust_visiting>
				<spread_home>-0.5</spread_home>
				<spread_adjust_home>186</spread_adjust_home>
			</spread>
			<total>
				<total_points>1.5</total_points>
				<over_adjust>116</over_adjust>
				<under_adjust>-126</under_adjust>
			</total>
		</period>
	</periods>
</event>
<event>
	<event_datetimeGMT>2011-03-31 00:49</event_datetimeGMT>
	<gamenumber>198629052</gamenumber>
	<sporttype>Soccer</sporttype>
	<league>Brazil Cup</league>
	<IsLive>No</IsLive>
	<participants>
		<participant>
			<participant_name>ABC RN</participant_name>
			<contestantnum>8104</contestantnum>
			<rotnum>8104</rotnum>
			<visiting_home_draw>Home</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>Vasco da Gama</participant_name>
			<contestantnum>8105</contestantnum>
			<rotnum>8105</rotnum>
			<visiting_home_draw>Visiting</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>Draw</participant_name>
			<contestantnum>8106</contestantnum>
			<rotnum>8106</rotnum>
			<visiting_home_draw>Draw</visiting_home_draw>
		</participant>
	</participants>
	<periods>
		<period>
			<period_number>0</period_number>
			<period_description>Game</period_description>
			<periodcutoff_datetimeGMT>2011-03-31 00:49</periodcutoff_datetimeGMT>
			<period_status>I</period_status>
			<period_update>open</period_update>
			<spread_maximum>500</spread_maximum>
			<moneyline_maximum>500</moneyline_maximum>
			<total_maximum>500</total_maximum>
			<moneyline>
				<moneyline_visiting>-110</moneyline_visiting>
				<moneyline_home>320</moneyline_home>
				<moneyline_draw>272</moneyline_draw>
			</moneyline>
			<spread>
				<spread_visiting>-0.5</spread_visiting>
				<spread_adjust_visiting>-109</spread_adjust_visiting>
				<spread_home>0.5</spread_home>
				<spread_adjust_home>-103</spread_adjust_home>
			</spread>
			<total>
				<total_points>2.75</total_points>
				<over_adjust>-123</over_adjust>
				<under_adjust>109</under_adjust>
			</total>
		</period>
	</periods>
</event>
<event>
	<event_datetimeGMT>2011-03-30 18:44</event_datetimeGMT>
	<gamenumber>198171851</gamenumber>
	<sporttype>Soccer</sporttype>
	<league>Eng L2</league>
	<IsLive>No</IsLive>
	<participants>
		<participant>
			<participant_name>Accrington Stanley</participant_name>
			<contestantnum>3181</contestantnum>
			<rotnum>3181</rotnum>
			<visiting_home_draw>Home</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>Hereford United</participant_name>
			<contestantnum>3182</contestantnum>
			<rotnum>3182</rotnum>
			<visiting_home_draw>Visiting</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>Draw</participant_name>
			<contestantnum>3183</contestantnum>
			<rotnum>3183</rotnum>
			<visiting_home_draw>Draw</visiting_home_draw>
		</participant>
	</participants>
	<periods>
		<period>
			<period_number>0</period_number>
			<period_description>Game</period_description>
			<periodcutoff_datetimeGMT>2011-03-30 18:44</periodcutoff_datetimeGMT>
			<period_status>O</period_status>
			<period_update>open</period_update>
			<spread_maximum>2000</spread_maximum>
			<moneyline_maximum>1000</moneyline_maximum>
			<total_maximum>1000</total_maximum>
			<moneyline>
				<moneyline_visiting>417</moneyline_visiting>
				<moneyline_home>-144</moneyline_home>
				<moneyline_draw>315</moneyline_draw>
			</moneyline>
			<spread>
				<spread_visiting>0.75</spread_visiting>
				<spread_adjust_visiting>-103</spread_adjust_visiting>
				<spread_home>-0.75</spread_home>
				<spread_adjust_home>-107</spread_adjust_home>
			</spread>
			<total>
				<total_points>2.5</total_points>
				<over_adjust>-131</over_adjust>
				<under_adjust>116</under_adjust>
			</total>
		</period>
	</periods>
</event>
<event>
	<event_datetimeGMT>2011-03-30 18:44</event_datetimeGMT>
	<gamenumber>198171852</gamenumber>
	<sporttype>Soccer</sporttype>
	<league>Eng L2</league>
	<IsLive>No</IsLive>
	<participants>
		<participant>
			<participant_name>Burton Albion</participant_name>
			<contestantnum>3184</contestantnum>
			<rotnum>3184</rotnum>
			<visiting_home_draw>Home</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>Macclesfield Town</participant_name>
			<contestantnum>3185</contestantnum>
			<rotnum>3185</rotnum>
			<visiting_home_draw>Visiting</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>Draw</participant_name>
			<contestantnum>3186</contestantnum>
			<rotnum>3186</rotnum>
			<visiting_home_draw>Draw</visiting_home_draw>
		</participant>
	</participants>
	<periods>
		<period>
			<period_number>0</period_number>
			<period_description>Game</period_description>
			<periodcutoff_datetimeGMT>2011-03-30 18:44</periodcutoff_datetimeGMT>
			<period_status>O</period_status>
			<period_update>open</period_update>
			<spread_maximum>2000</spread_maximum>
			<moneyline_maximum>1000</moneyline_maximum>
			<total_maximum>1000</total_maximum>
			<moneyline>
				<moneyline_visiting>214</moneyline_visiting>
				<moneyline_home>137</moneyline_home>
				<moneyline_draw>252</moneyline_draw>
			</moneyline>
			<spread>
				<spread_visiting>0.25</spread_visiting>
				<spread_adjust_visiting>-116</spread_adjust_visiting>
				<spread_home>-0.25</spread_home>
				<spread_adjust_home>105</spread_adjust_home>
			</spread>
			<total>
				<total_points>2.5</total_points>
				<over_adjust>-108</over_adjust>
				<under_adjust>-104</under_adjust>
			</total>
		</period>
	</periods>
</event>
<event>
	<event_datetimeGMT>2011-04-02 16:59</event_datetimeGMT>
	<gamenumber>197922250</gamenumber>
	<sporttype>Soccer</sporttype>
	<league>French 1</league>
	<IsLive>No</IsLive>
	<participants>
		<participant>
			<participant_name>Stade Rennais</participant_name>
			<contestantnum>1969</contestantnum>
			<rotnum>1969</rotnum>
			<visiting_home_draw>Home</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>Auxerre</participant_name>
			<contestantnum>1970</contestantnum>
			<rotnum>1970</rotnum>
			<visiting_home_draw>Visiting</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>Draw</participant_name>
			<contestantnum>1971</contestantnum>
			<rotnum>1971</rotnum>
			<visiting_home_draw>Draw</visiting_home_draw>
		</participant>
	</participants>
	<periods>
		<period>
			<period_number>0</period_number>
			<period_description>Game</period_description>
			<periodcutoff_datetimeGMT>2011-04-02 16:59</periodcutoff_datetimeGMT>
			<period_status>H</period_status>
			<period_update>offline</period_update>
			<spread_maximum>8000</spread_maximum>
			<moneyline_maximum>4000</moneyline_maximum>
			<total_maximum>4000</total_maximum>
			<moneyline>
				<moneyline_visiting>473</moneyline_visiting>
				<moneyline_home>-138</moneyline_home>
				<moneyline_draw>263</moneyline_draw>
			</moneyline>
			<spread>
				<spread_visiting>0.75</spread_visiting>
				<spread_adjust_visiting>-111</spread_adjust_visiting>
				<spread_home>-0.75</spread_home>
				<spread_adjust_home>103</spread_adjust_home>
			</spread>
			<total>
				<total_points>2</total_points>
				<over_adjust>-104</over_adjust>
				<under_adjust>-106</under_adjust>
			</total>
		</period>
	</periods>
</event>
<event>
	<event_datetimeGMT>2011-03-30 18:59</event_datetimeGMT>
	<gamenumber>198715457</gamenumber>
	<sporttype>Soccer</sporttype>
	<league>Iceland Cup</league>
	<IsLive>No</IsLive>
	<participants>
		<participant>
			<participant_name>Haukar Hafnarfjordur</participant_name>
			<contestantnum>3801</contestantnum>
			<rotnum>3801</rotnum>
			<visiting_home_draw>Home</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>Grindavik</participant_name>
			<contestantnum>3802</contestantnum>
			<rotnum>3802</rotnum>
			<visiting_home_draw>Visiting</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>Draw</participant_name>
			<contestantnum>3803</contestantnum>
			<rotnum>3803</rotnum>
			<visiting_home_draw>Draw</visiting_home_draw>
		</participant>
	</participants>
	<periods>
		<period>
			<period_number>0</period_number>
			<period_description>Game</period_description>
			<periodcutoff_datetimeGMT>2011-03-30 18:59</periodcutoff_datetimeGMT>
			<period_status>O</period_status>
			<period_update>open</period_update>
			<spread_maximum>500</spread_maximum>
			<moneyline_maximum>500</moneyline_maximum>
			<total_maximum>500</total_maximum>
			<moneyline>
				<moneyline_visiting>107</moneyline_visiting>
				<moneyline_home>241</moneyline_home>
				<moneyline_draw>281</moneyline_draw>
			</moneyline>
			<spread>
				<spread_visiting>-0.25</spread_visiting>
				<spread_adjust_visiting>-120</spread_adjust_visiting>
				<spread_home>0.25</spread_home>
				<spread_adjust_home>103</spread_adjust_home>
			</spread>
			<total>
				<total_points>3</total_points>
				<over_adjust>-136</over_adjust>
				<under_adjust>116</under_adjust>
			</total>
		</period>
	</periods>
</event>
<event>
	<event_datetimeGMT>2011-03-30 18:59</event_datetimeGMT>
	<gamenumber>198715480</gamenumber>
	<sporttype>Soccer</sporttype>
	<league>Intl Friendl</league>
	<IsLive>No</IsLive>
	<participants>
		<participant>
			<participant_name>Morocco</participant_name>
			<contestantnum>6001</contestantnum>
			<rotnum>6001</rotnum>
			<visiting_home_draw>Home</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>Botswana</participant_name>
			<contestantnum>6002</contestantnum>
			<rotnum>6002</rotnum>
			<visiting_home_draw>Visiting</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>Draw</participant_name>
			<contestantnum>6003</contestantnum>
			<rotnum>6003</rotnum>
			<visiting_home_draw>Draw</visiting_home_draw>
		</participant>
	</participants>
	<periods>
		<period>
			<period_number>0</period_number>
			<period_description>Game</period_description>
			<periodcutoff_datetimeGMT>2011-03-30 18:59</periodcutoff_datetimeGMT>
			<period_status>O</period_status>
			<period_update>open</period_update>
			<spread_maximum>1000</spread_maximum>
			<moneyline_maximum>1000</moneyline_maximum>
			<total_maximum>1000</total_maximum>
			<moneyline>
				<moneyline_visiting>401</moneyline_visiting>
				<moneyline_home>-136</moneyline_home>
				<moneyline_draw>293</moneyline_draw>
			</moneyline>
			<spread>
				<spread_visiting>0.75</spread_visiting>
				<spread_adjust_visiting>-108</spread_adjust_visiting>
				<spread_home>-0.75</spread_home>
				<spread_adjust_home>-104</spread_adjust_home>
			</spread>
			<total>
				<total_points>2.5</total_points>
				<over_adjust>-118</over_adjust>
				<under_adjust>105</under_adjust>
			</total>
		</period>
	</periods>
</event>
<event>
	<event_datetimeGMT>2011-04-01 18:34</event_datetimeGMT>
	<gamenumber>198172550</gamenumber>
	<sporttype>Soccer</sporttype>
	<league>Irish</league>
	<IsLive>No</IsLive>
	<participants>
		<participant>
			<participant_name>St Patricks Athletic</participant_name>
			<contestantnum>3671</contestantnum>
			<rotnum>3671</rotnum>
			<visiting_home_draw>Home</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>Bohemians</participant_name>
			<contestantnum>3672</contestantnum>
			<rotnum>3672</rotnum>
			<visiting_home_draw>Visiting</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>Draw</participant_name>
			<contestantnum>3673</contestantnum>
			<rotnum>3673</rotnum>
			<visiting_home_draw>Draw</visiting_home_draw>
		</participant>
	</participants>
	<periods>
		<period>
			<period_number>0</period_number>
			<period_description>Game</period_description>
			<periodcutoff_datetimeGMT>2011-04-01 18:34</periodcutoff_datetimeGMT>
			<period_status>I</period_status>
			<period_update>open</period_update>
			<spread_maximum>1500</spread_maximum>
			<moneyline_maximum>500</moneyline_maximum>
			<total_maximum>500</total_maximum>
			<moneyline>
				<moneyline_visiting>298</moneyline_visiting>
				<moneyline_home>109</moneyline_home>
				<moneyline_draw>233</moneyline_draw>
			</moneyline>
			<spread>
				<spread_visiting>0.5</spread_visiting>
				<spread_adjust_visiting>-117</spread_adjust_visiting>
				<spread_home>-0.5</spread_home>
				<spread_adjust_home>106</spread_adjust_home>
			</spread>
			<total>
				<total_points>2.25</total_points>
				<over_adjust>111</over_adjust>
				<under_adjust>-125</under_adjust>
			</total>
		</period>
	</periods>
</event>
<event>
	<event_datetimeGMT>2011-04-01 18:44</event_datetimeGMT>
	<gamenumber>198172548</gamenumber>
	<sporttype>Soccer</sporttype>
	<league>Irish</league>
	<IsLive>No</IsLive>
	<participants>
		<participant>
			<participant_name>Dundalk</participant_name>
			<contestantnum>3680</contestantnum>
			<rotnum>3680</rotnum>
			<visiting_home_draw>Home</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>UC Dublin</participant_name>
			<contestantnum>3681</contestantnum>
			<rotnum>3681</rotnum>
			<visiting_home_draw>Visiting</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>Draw</participant_name>
			<contestantnum>3682</contestantnum>
			<rotnum>3682</rotnum>
			<visiting_home_draw>Draw</visiting_home_draw>
		</participant>
	</participants>
	<periods>
		<period>
			<period_number>0</period_number>
			<period_description>Game</period_description>
			<periodcutoff_datetimeGMT>2011-04-01 18:44</periodcutoff_datetimeGMT>
			<period_status>I</period_status>
			<period_update>open</period_update>
			<spread_maximum>1500</spread_maximum>
			<moneyline_maximum>500</moneyline_maximum>
			<total_maximum>500</total_maximum>
			<moneyline>
				<moneyline_visiting>490</moneyline_visiting>
				<moneyline_home>-150</moneyline_home>
				<moneyline_draw>280</moneyline_draw>
			</moneyline>
			<spread>
				<spread_visiting>0.75</spread_visiting>
				<spread_adjust_visiting>106</spread_adjust_visiting>
				<spread_home>-0.75</spread_home>
				<spread_adjust_home>-117</spread_adjust_home>
			</spread>
			<total>
				<total_points>2.25</total_points>
				<over_adjust>-115</over_adjust>
				<under_adjust>102</under_adjust>
			</total>
		</period>
	</periods>
</event>
<event>
	<event_datetimeGMT>2011-04-01 18:59</event_datetimeGMT>
	<gamenumber>198172507</gamenumber>
	<sporttype>Soccer</sporttype>
	<league>Irish Div1</league>
	<IsLive>No</IsLive>
	<participants>
		<participant>
			<participant_name>Wexford Youths</participant_name>
			<contestantnum>5277</contestantnum>
			<rotnum>5277</rotnum>
			<visiting_home_draw>Home</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>Mervue United FC</participant_name>
			<contestantnum>5278</contestantnum>
			<rotnum>5278</rotnum>
			<visiting_home_draw>Visiting</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>Draw</participant_name>
			<contestantnum>5279</contestantnum>
			<rotnum>5279</rotnum>
			<visiting_home_draw>Draw</visiting_home_draw>
		</participant>
	</participants>
	<periods>
		<period>
			<period_number>0</period_number>
			<period_description>Game</period_description>
			<periodcutoff_datetimeGMT>2011-04-01 18:59</periodcutoff_datetimeGMT>
			<period_status>H</period_status>
			<period_update>offline</period_update>
			<spread_maximum>1000</spread_maximum>
			<moneyline_maximum>1000</moneyline_maximum>
			<total_maximum>1000</total_maximum>
			<spread>
				<spread_visiting>0.5</spread_visiting>
				<spread_adjust_visiting>104</spread_adjust_visiting>
				<spread_home>-0.5</spread_home>
				<spread_adjust_home>-117</spread_adjust_home>
			</spread>
			<total>
				<total_points>2.5</total_points>
				<over_adjust>111</over_adjust>
				<under_adjust>-125</under_adjust>
			</total>
		</period>
	</periods>
</event>
<event>
	<event_datetimeGMT>2011-04-03 16:59</event_datetimeGMT>
	<gamenumber>198055293</gamenumber>
	<sporttype>Soccer</sporttype>
	<league>Norwegian T</league>
	<IsLive>No</IsLive>
	<participants>
		<participant>
			<participant_name>Molde</participant_name>
			<contestantnum>2904</contestantnum>
			<rotnum>2904</rotnum>
			<visiting_home_draw>Home</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>Tromso</participant_name>
			<contestantnum>2905</contestantnum>
			<rotnum>2905</rotnum>
			<visiting_home_draw>Visiting</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>Draw</participant_name>
			<contestantnum>2906</contestantnum>
			<rotnum>2906</rotnum>
			<visiting_home_draw>Draw</visiting_home_draw>
		</participant>
	</participants>
	<periods>
		<period>
			<period_number>0</period_number>
			<period_description>Game</period_description>
			<periodcutoff_datetimeGMT>2011-04-03 16:59</periodcutoff_datetimeGMT>
			<period_status>I</period_status>
			<period_update>open</period_update>
			<spread_maximum>2000</spread_maximum>
			<moneyline_maximum>1000</moneyline_maximum>
			<total_maximum>1000</total_maximum>
			<moneyline>
				<moneyline_visiting>289</moneyline_visiting>
				<moneyline_home>104</moneyline_home>
				<moneyline_draw>252</moneyline_draw>
			</moneyline>
			<spread>
				<spread_visiting>0.5</spread_visiting>
				<spread_adjust_visiting>-113</spread_adjust_visiting>
				<spread_home>-0.5</spread_home>
				<spread_adjust_home>104</spread_adjust_home>
			</spread>
			<total>
				<total_points>2.5</total_points>
				<over_adjust>107</over_adjust>
				<under_adjust>-118</under_adjust>
			</total>
		</period>
	</periods>
</event>
<event>
	<event_datetimeGMT>2011-04-03 16:59</event_datetimeGMT>
	<gamenumber>198055299</gamenumber>
	<sporttype>Soccer</sporttype>
	<league>Norwegian T</league>
	<IsLive>No</IsLive>
	<participants>
		<participant>
			<participant_name>Sogndal</participant_name>
			<contestantnum>2907</contestantnum>
			<rotnum>2907</rotnum>
			<visiting_home_draw>Home</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>Odd Grenland</participant_name>
			<contestantnum>2908</contestantnum>
			<rotnum>2908</rotnum>
			<visiting_home_draw>Visiting</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>Draw</participant_name>
			<contestantnum>2909</contestantnum>
			<rotnum>2909</rotnum>
			<visiting_home_draw>Draw</visiting_home_draw>
		</participant>
	</participants>
	<periods>
		<period>
			<period_number>0</period_number>
			<period_description>Game</period_description>
			<periodcutoff_datetimeGMT>2011-04-03 16:59</periodcutoff_datetimeGMT>
			<period_status>I</period_status>
			<period_update>open</period_update>
			<spread_maximum>2000</spread_maximum>
			<moneyline_maximum>1000</moneyline_maximum>
			<total_maximum>1000</total_maximum>
			<moneyline>
				<moneyline_visiting>182</moneyline_visiting>
				<moneyline_home>160</moneyline_home>
				<moneyline_draw>243</moneyline_draw>
			</moneyline>
			<spread>
				<spread_visiting>0</spread_visiting>
				<spread_adjust_visiting>104</spread_adjust_visiting>
				<spread_home>0</spread_home>
				<spread_adjust_home>-113</spread_adjust_home>
			</spread>
			<total>
				<total_points>2.5</total_points>
				<over_adjust>100</over_adjust>
				<under_adjust>-110</under_adjust>
			</total>
		</period>
	</periods>
</event>
<event>
	<event_datetimeGMT>2011-03-30 18:44</event_datetimeGMT>
	<gamenumber>198559830</gamenumber>
	<sporttype>Soccer</sporttype>
	<league>Scot. FA Cup</league>
	<IsLive>No</IsLive>
	<participants>
		<participant>
			<participant_name>Motherwell</participant_name>
			<contestantnum>3422</contestantnum>
			<rotnum>3422</rotnum>
			<visiting_home_draw>Home</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>Dundee United</participant_name>
			<contestantnum>3423</contestantnum>
			<rotnum>3423</rotnum>
			<visiting_home_draw>Visiting</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>Draw</participant_name>
			<contestantnum>3424</contestantnum>
			<rotnum>3424</rotnum>
			<visiting_home_draw>Draw</visiting_home_draw>
		</participant>
	</participants>
	<periods>
		<period>
			<period_number>0</period_number>
			<period_description>Game</period_description>
			<periodcutoff_datetimeGMT>2011-03-30 18:44</periodcutoff_datetimeGMT>
			<period_status>O</period_status>
			<period_update>open</period_update>
			<spread_maximum>3000</spread_maximum>
			<moneyline_maximum>1500</moneyline_maximum>
			<total_maximum>1500</total_maximum>
			<moneyline>
				<moneyline_visiting>157</moneyline_visiting>
				<moneyline_home>195</moneyline_home>
				<moneyline_draw>236</moneyline_draw>
			</moneyline>
			<spread>
				<spread_visiting>0</spread_visiting>
				<spread_adjust_visiting>-119</spread_adjust_visiting>
				<spread_home>0</spread_home>
				<spread_adjust_home>108</spread_adjust_home>
			</spread>
			<total>
				<total_points>2.25</total_points>
				<over_adjust>106</over_adjust>
				<under_adjust>-119</under_adjust>
			</total>
		</period>
	</periods>
</event>
<event>
	<event_datetimeGMT>2011-03-31 18:30</event_datetimeGMT>
	<gamenumber>198585853</gamenumber>
	<sporttype>Volleyball</sporttype>
	<league>Italy S A1 W</league>
	<IsLive>No</IsLive>
	<participants>
		<participant>
			<participant_name>LIU JO Volley Modena</participant_name>
			<contestantnum>4503</contestantnum>
			<rotnum>4503</rotnum>
			<visiting_home_draw>Home</visiting_home_draw>
		</participant>
		<participant>
			<participant_name>Spes Conegliano</participant_name>
			<contestantnum>4504</contestantnum>
			<rotnum>4504</rotnum>
			<visiting_home_draw>Visiting</visiting_home_draw>
		</participant>
	</participants>
	<periods>
		<period>
			<period_number>0</period_number>
			<period_description>Game</period_description>
			<periodcutoff_datetimeGMT>2011-03-31 18:30</periodcutoff_datetimeGMT>
			<period_status>I</period_status>
			<period_update>open</period_update>
			<spread_maximum>50</spread_maximum>
			<moneyline_maximum>50</moneyline_maximum>
			<total_maximum>50</total_maximum>
			<moneyline>
				<moneyline_visiting>-166</moneyline_visiting>
				<moneyline_home>147</moneyline_home>
			</moneyline>
			<spread>
				<spread_visiting>-1.5</spread_visiting>
				<spread_adjust_visiting>112</spread_adjust_visiting>
				<spread_home>1.5</spread_home>
				<spread_adjust_home>-126</spread_adjust_home>
			</spread>
			<total>
				<total_points>4.5</total_points>
				<over_adjust>250</over_adjust>
				<under_adjust>-290</under_adjust>
			</total>
		</period>
	</periods>
</event>
<event>
	<event_datetimeGMT>2011-03-31 12:50</event_datetimeGMT>
	<gamenumber>198632609</gamenumber>
	<sporttype>Golf</sporttype>
	<league>100* Shell Houston Open: Tournament Matchups</league>
	<contest_maximum>2000</contest_maximum>
	<description>F. Couples vs S. Appleby</description>
	<participants>
		<participant>
			<participant_name>F. Couples</participant_name>
			<contestantnum>198632610</contestantnum>
			<rotnum>7017</rotnum>
			<odds>
				<moneyline_value>-121</moneyline_value>
				<to_base>0</to_base>
			</odds>
		</participant>
		<participant>
			<participant_name>S. Appleby</participant_name>
			<contestantnum>198632611</contestantnum>
			<rotnum>7018</rotnum>
			<odds>
				<moneyline_value>110</moneyline_value>
				<to_base>0</to_base>
			</odds>
		</participant>
	</participants>
</event>
<event>
	<event_datetimeGMT>2011-03-31 14:00</event_datetimeGMT>
	<gamenumber>198632705</gamenumber>
	<sporttype>Golf</sporttype>
	<league>100* Shell Houston Open: Tournament Matchups</league>
	<contest_maximum>2000</contest_maximum>
	<description>C. Knost vs M. Sim</description>
	<participants>
		<participant>
			<participant_name>C. Knost</participant_name>
			<contestantnum>198632706</contestantnum>
			<rotnum>7029</rotnum>
			<odds>
				<moneyline_value>-137</moneyline_value>
				<to_base>0</to_base>
			</odds>
		</participant>
		<participant>
			<participant_name>M. Sim</participant_name>
			<contestantnum>198632707</contestantnum>
			<rotnum>7030</rotnum>
			<odds>
				<moneyline_value>124</moneyline_value>
				<to_base>0</to_base>
			</odds>
		</participant>
	</participants>
</event>
<event>
	<event_datetimeGMT>2011-03-31 17:40</event_datetimeGMT>
	<gamenumber>198632662</gamenumber>
	<sporttype>Golf</sporttype>
	<league>100* Shell Houston Open: Tournament Matchups</league>
	<contest_maximum>2000</contest_maximum>
	<description>L. Oosthuizen vs R. Fisher</description>
	<participants>
		<participant>
			<participant_name>L. Oosthuizen</participant_name>
			<contestantnum>198632663</contestantnum>
			<rotnum>7023</rotnum>
			<odds>
				<moneyline_value>-127</moneyline_value>
				<to_base>0</to_base>
			</odds>
		</participant>
		<participant>
			<participant_name>R. Fisher</participant_name>
			<contestantnum>198632664</contestantnum>
			<rotnum>7024</rotnum>
			<odds>
				<moneyline_value>115</moneyline_value>
				<to_base>0</to_base>
			</odds>
		</participant>
	</participants>
</event>

</events>
</pinnacle_line_feed>
