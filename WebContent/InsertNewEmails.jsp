<%@ page language="java" contentType="text/html; charset=windows-1255"
	pageEncoding="windows-1255"
	import="javax.xml.transform.stream.StreamResult,javax.xml.transform.dom.DOMSource,org.w3c.dom.*,javax.xml.parsers.DocumentBuilderFactory,javax.xml.parsers.DocumentBuilder,org.w3c.dom.Document,org.w3c.dom.NodeList,org.w3c.dom.Node,org.w3c.dom.Element,java.io.File,javax.xml.transform.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
	String emailsPath = "C:\\emails.xml";
	if (request.getParameter("data") != null) {
		String[] s = request.getParameter("data").split("\n");
		String category = request.getParameter("cat");

		File fXmlFile = new File(emailsPath);
		DocumentBuilderFactory dbFactory = DocumentBuilderFactory
				.newInstance();
		DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
		Document doc = dBuilder.parse(fXmlFile);
		for (String em : s) {
			Node newElem = doc.createElement("email");
			Node e = doc.createElement("addr");
			e.setTextContent(em);
			newElem.appendChild(e);
			e = doc.createElement("ver");
			e.setTextContent("0");
			newElem.appendChild(e);
			e = doc.createElement("cat");
			e.setTextContent(category);
			newElem.appendChild(e);

			doc.getDocumentElement().appendChild(newElem);
		}

		TransformerFactory transformerFactory = TransformerFactory
				.newInstance();
		Transformer transformer = transformerFactory.newTransformer();
		DOMSource source = new DOMSource(doc);
		StreamResult result = new StreamResult(new File(emailsPath));

		// Output to console for testing
		// StreamResult result = new StreamResult(System.out);

		transformer.transform(source, result);

		//doc.appendChild(newChild)

	}
	/*
	private Node getEmail(String email, String category,XmlDocument doc)
	{
	    XmlElement newElem = doc.CreateElement("email");
	    XmlElement e= doc.CreateElement("addr");
	    e.InnerText = email.TrimEnd('\r',' ');
	    newElem.AppendChild(e);
	    e = doc.CreateElement("ver");
	    e.InnerText = "0";
	    newElem.AppendChild(e);
	    e = doc.CreateElement("cat");
	    e.InnerText = category;
	    newElem.AppendChild(e);

	    return newElem;
	}*/
	/*
	 if (Request.Form["data"] != null)
	 {
	 string[] s = Request.Form["data"].Split('\n');
	 string category = Request.Form["cat"];
	 XmlDocument doc = new XmlDocument();
	 doc.Load(emailsPath);

	 foreach (string email in s)
	 {
	 doc.DocumentElement.AppendChild(setNewEmail(email,category,doc));
	 }

	 // Save the document to a file. White space is
	 // preserved (no white space).
	 doc.PreserveWhitespace = true;
	 doc.Save(emailsPath);
	 }*/
%>
<html>
<head>
<title></title>
<style>
.none {
	margin-left: 0px;
}
</style>
</head>
<body>
	<form action="InsertNewEmails.jsp" method="post">
		<table style="margin: auto">
			<tr>
				<td class="none">Catergory</td>
				<td><input type="text" name="cat" style="width: 100%"
					class="none" /></td>
			</tr>
			<tr>
				<td class="none">List emails</td>
				<td class="none"><textarea name="data"></textarea></td>
			</tr>
			<tr>
				<td colspan="2"><input type="submit" value="Send!"
					style="width: 100%" /></td>
			</tr>
		</table>
	</form>
</body>
</html>
