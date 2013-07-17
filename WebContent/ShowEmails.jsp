<%@ page language="java" contentType="text/html; charset=windows-1255"
	pageEncoding="windows-1255"
	import="javax.xml.parsers.DocumentBuilderFactory,javax.xml.parsers.DocumentBuilder,org.w3c.dom.Document,org.w3c.dom.NodeList,org.w3c.dom.Node,org.w3c.dom.Element,java.io.File"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">


<%
	String emailsPath = "C:\\emails.xml";
	String emails = "";

	File fXmlFile = new File(emailsPath);
	DocumentBuilderFactory dbFactory = DocumentBuilderFactory
			.newInstance();
	DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
	Document doc = dBuilder.parse(fXmlFile);
	NodeList nl = doc.getDocumentElement()
			.getElementsByTagName("email");
	for (int i = 0; i < nl.getLength(); i++) {
		Node email = nl.item(i);
		if (email.getChildNodes().getLength() == 3)
			emails += "{addr:'"
					+ email.getChildNodes().item(0).getTextContent()
					+ "' , ver:'"
					+ email.getChildNodes().item(1).getTextContent()
					+ "',category:'"
					+ email.getChildNodes().item(2).getTextContent()
					+ "'},";
	}
	try {
		emails = emails.substring(0, emails.length() - 1);
	} catch (Exception e) {
		response.getWriter().print("There are no emails");
		out.flush();
		out.close();
		return;
	}
%>

<html ng-app="myApp">
<head>
<title></title>
<style type="text/css">
h1 {
	text-align: center;
	width: 100%;
}

.CSSTableGenerator {
	margin: 0px;
	padding: 0px;
	width: 100%;
	box-shadow: 10px 10px 5px #888888;
	border: 1px solid #000000;
	-moz-border-radius-bottomleft: 7px;
	-webkit-border-bottom-left-radius: 7px;
	border-bottom-left-radius: 7px;
	-moz-border-radius-bottomright: 7px;
	-webkit-border-bottom-right-radius: 7px;
	border-bottom-right-radius: 7px;
	-moz-border-radius-topright: 7px;
	-webkit-border-top-right-radius: 7px;
	border-top-right-radius: 7px;
	-moz-border-radius-topleft: 7px;
	-webkit-border-top-left-radius: 7px;
	border-top-left-radius: 7px;
}

.CSSTableGenerator table {
	width: 100%;
	height: 100%;
	margin: 0px;
	padding: 0px;
}

.CSSTableGenerator tr:last-child td:last-child {
	-moz-border-radius-bottomright: 7px;
	-webkit-border-bottom-right-radius: 7px;
	border-bottom-right-radius: 7px;
}

.CSSTableGenerator table tr:first-child td:first-child {
	-moz-border-radius-topleft: 7px;
	-webkit-border-top-left-radius: 7px;
	border-top-left-radius: 7px;
}

.CSSTableGenerator table tr:first-child td:last-child {
	-moz-border-radius-topright: 7px;
	-webkit-border-top-right-radius: 7px;
	border-top-right-radius: 7px;
}

.CSSTableGenerator tr:last-child td:first-child {
	-moz-border-radius-bottomleft: 7px;
	-webkit-border-bottom-left-radius: 7px;
	border-bottom-left-radius: 7px;
}

.CSSTableGenerator tr:hover td {
	background-color: #ffffff;
}

.CSSTableGenerator td {
	vertical-align: middle;
	background-color: #d3e9ff;
	border: 1px solid #000000;
	border-width: 0px 1px 1px 0px;
	text-align: center;
	padding: 7px;
	font-size: 14px;
	font-family: Arial;
	font-weight: normal;
	color: #000000;
}

.CSSTableGenerator tr:last-child td {
	border-width: 0px 1px 0px 0px;
}

.CSSTableGenerator tr td:last-child {
	border-width: 0px 0px 1px 0px;
}

.CSSTableGenerator tr:last-child td:last-child {
	border-width: 0px 0px 0px 0px;
}

.CSSTableGenerator tr:first-child td {
	background: -o-linear-gradient(bottom, #0057af 5%, #007fff 100%);
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.05, #0057af
		), color-stop(1, #007fff));
	background: -moz-linear-gradient(center top, #0057af 5%, #007fff 100%);
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr="#0057af",
		endColorstr="#007fff");
	background: -o-linear-gradient(top, #0057af, 007fff);
	background-color: #0057af;
	border: 0px solid #000000;
	text-align: center;
	border-width: 0px 0px 1px 1px;
	font-size: 16px;
	font-family: Arial;
	font-weight: bold;
	color: #ffffff;
}

.CSSTableGenerator tr:first-child:hover td {
	background: -o-linear-gradient(bottom, #0057af 5%, #007fff 100%);
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.05, #0057af
		), color-stop(1, #007fff));
	background: -moz-linear-gradient(center top, #0057af 5%, #007fff 100%);
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr="#0057af",
		endColorstr="#007fff");
	background: -o-linear-gradient(top, #0057af, 007fff);
	background-color: #0057af;
}

.CSSTableGenerator tr:first-child td:first-child {
	border-width: 0px 0px 1px 0px;
}

.CSSTableGenerator tr:first-child td:last-child {
	border-width: 0px 0px 1px 1px;
}
</style>
<script type="text/javascript" src="json2.js"></script>
<script type="text/javascript" src="mandrill.min.js"></script>
<script src="http://code.angularjs.org/1.0.6/angular.min.js"></script>
<script type="text/javascript">
	angular.module('myApp', [ 'filters' ]);

	angular.module('filters', []).filter('biggerThen', function($filter) {
		return function(input, bigger) {
			if (isNaN(bigger))
				bigger = 0;
			ret = new Array();
			for ( var i = 0; i < input.length; i++) {
				if (input[i].ver * 1 >= bigger)
					ret.push(input[i]);
			}
			return ret;
		};
	});

	m = new mandrill.Mandrill('ZlHLnYVxFFU7HA2AW1DV1w');

	/*
	m.users.info(function(res) {
	    onSuccessLog(res);
	}, function(err) {
	    alert(err);
	});
	
	function onSuccessLog(obj) {
		alert(JSON.stringify(obj.stats.last_7_days.sent) + ' emails sent.');
		alert(JSON.stringify(obj.stats.last_7_days.opens) + ' total opens.');
	}*/
	function getMsgsStatus()
	{
		m.senders.list(function(arr) {
			onSuccessLog(arr);
		});
	}
	function onSuccessLog(arr) {
		s = "";
		for(var i = 0;i<arr.length;i++)
			s+= arr[i].address +": { sent:" +  arr[i].sent + ", opened:" + arr[i].opens+ "}\n";
		alert(s);
	}
	
	
	function Main($scope) {
		$scope.emails = [
<%=emails%>
	];
		$scope.msgBuilder = {
			"from" : "svspammer101@gmail.com",
			"subject" : "Wellcome fitness!",
			"html" : "Write here whatever"
		};

		$scope.sendSpecEmail = function(email) {
			var params = {
				"message" : {
					"from_email" : $scope.msgBuilder.from,
					"to" : [ {
						"email" : email
					} ],
					"subject" : $scope.msgBuilder.subject,
					"html" : $scope.msgBuilder.html,
					"track_opens" : true,
				}
			};
			m.messages.send(params, function(res) {
				alert(JSON.stringify(res));
			}, function(err) {
				alert(JSON.stringify(err));
			});
		};

		$scope.sendEmails = function() {
			var params = {
				"message" : {
					"from_email" : $scope.msgBuilder.from,
					"to" : [ {} ],
					"subject" : $scope.msgBuilder.subject,
					"html" : $scope.msgBuilder.html,
					"track_opens" : true
				}
			};
			for ( var i = 0; i < $scope.filtered.length;) {
				for ( var j = 0; j < 500 && i < $scope.filtered.length; i++, j++) {
					if ($scope.filtered[i].addr != null
							&& $scope.filtered[i].addr != ""
							&& $scope.filtered[i].addr.indexOf('@') != -1)
						params.message.to.push({
							"email" : $scope.filtered[i].addr
						});
				}
				m.messages.send(params, function(res) {
					alert(JSON.stringify(res));
				}, function(err) {
					alert(JSON.stringify(err));
				});
			}
		};
	}
</script>
</head>
<body>
	<div style="width: 50%; margin: auto;">
		<div ng-controller="Main">
			<h1>Filter Mailing List</h1>
			<div class="CSSTableGenerator">
				<table style="margin: auto">
					<tr>
						<td>Property:</td>
						<td>Input</td>
					</tr>
					<tr>
						<td>email:</td>
						<td><input type="text" ng-model="search.addr" /></td>
					</tr>
					<tr>
						<td>Category:</td>
						<td><input type="text" ng-model="search.category" /></td>
					</tr>
					<tr>
						<td colspan="2">Number of matches: {{ filtered.length }}</td>

					</tr>
				</table>
			</div>
			<h1>Distribute an Email</h1>
			<div class="CSSTableGenerator">
				<table style="margin: auto">
					<tr>
						<td>Property:</td>
						<td>Input</td>
					</tr>
					<tr>
						<td>From:</td>
						<td><input type="text" ng-model="msgBuilder.from" /></td>
					</tr>
					<tr>
						<td>Subject:</td>
						<td><input type="text" ng-model="msgBuilder.subject" /></td>
					</tr>
					<tr>
						<td>Html content:</td>
						<td><textarea ng-model="msgBuilder.html"></textarea></td>
					</tr>
					<tr>
						<td colspan="2">
							<button ng-click="sendEmails()">Send to the {{
								filtered.length }} below</button>
							<button onclick="getMsgsStatus()">Get status</button>
						</td>
					</tr>
				</table>
			</div>
			<h1>Mailing List</h1>
			<div class="CSSTableGenerator">
				<table style="margin: auto">
					<tr>
						<td style="width: 20%">Address</td>
						<td style="width: 20%">Category</td>
						<td style="width: 20%">Send Email</td>
					</tr>
					<tr
						data-ng-repeat="email in filtered = ((emails | filter:search) | orderBy:'addr')">
						<td style="text-align: center">{{ email.addr }}</td>
						<td style="text-align: center">{{ email.category }}</td>
						<td style="text-align: center"><button value="Send an email"
								ng-click="sendSpecEmail(email.addr)">Send an email</button></td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</body>
</html>
