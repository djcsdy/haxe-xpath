/* dcxml by Daniel J. Cassidy <mail@danielcassidy.me.uk>
 * Dedicated to the Public Domain
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS AND ANY EXPRESS 
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */


package dcxml.unit.parser;
import dcxml.parser.XmlParser;
import dcxml.parser.XmlHandler;
import haxe.unit.TestCase;


class TestXmlParser extends TestCase {
	
	private function testEmpty () {
		var handler:TestHandler = new TestHandler();
		XmlParser.parse("", handler);
		assertEquals("SDED", handler.log);
	}
	
	private function testSimple () {
		var handler:TestHandler = new TestHandler();
		XmlParser.parse("<a/>", handler);
		assertEquals("SDSEa{}EEa ED", handler.log);
	}
	
	private function testSimple2 () {
		var handler:TestHandler = new TestHandler();
		XmlParser.parse("<a></a>", handler);
		assertEquals("SDSEa{}EEa ED", handler.log);
	}
	
	private function testSimple3 () {
		var handler:TestHandler = new TestHandler();
		XmlParser.parse("<a\n\t/>", handler);
		assertEquals("SDSEa{}EEa ED", handler.log);
	}

	private function testSimple4 () {
		var handler:TestHandler = new TestHandler();
		XmlParser.parse("<a   ></a        >", handler);
		assertEquals("SDSEa{}EEa ED", handler.log);
	}
	
	private function testSimpleAttributes () {
		var handler:TestHandler = new TestHandler();
		XmlParser.parse("<abc def='ghi' jkl=" + '"105.2"' + "/>", handler);
		assertEquals("SDSEabc{def=ghi jkl=105.2 }EEabc ED", handler.log);
	}
	
	private function testSimpleAttributes2 () {
		var handler:TestHandler = new TestHandler();
		XmlParser.parse("<abc def='ghi' jkl=" + '"105.2"' + "></abc>", handler);
		assertEquals("SDSEabc{def=ghi jkl=105.2 }EEabc ED", handler.log);
	}
	
	private function testSimpleAttributes3 () {
		var handler:TestHandler = new TestHandler();
		XmlParser.parse("<abc\n\tdef='ghi'\n\tjkl=" + '"105.2"' + "/>", handler);
		assertEquals("SDSEabc{def=ghi jkl=105.2 }EEabc ED", handler.log);
	}
	
	private function testSimpleAttributes4 () {
		var handler:TestHandler = new TestHandler();
		XmlParser.parse("<abc\n\tdef='ghi'\n\tjkl=" + '"105.2"' + "\n></abc    >", handler);
		assertEquals("SDSEabc{def=ghi jkl=105.2 }EEabc ED", handler.log);
	}
	
	private function testCData () {
		var handler:TestHandler = new TestHandler();
		XmlParser.parse("<![CDATA[ABC][<>'" + '"' + "]]>", handler);
		assertEquals("SDSCCH{ABC][<>'" + '"' + "}ECED", handler.log);
	}
	
	private function testComment () {
		var handler:TestHandler = new TestHandler();
		XmlParser.parse("<!--sgjssg-->", handler);
		assertEquals("SDCO{sgjssg}ED", handler.log);
	}
	
	private function testProcessingInstruction () {
		var handler:TestHandler = new TestHandler();
		XmlParser.parse("<?xml version='1.0'?>", handler);
		assertEquals("SDPIxml{version='1.0'}ED", handler.log);
	}
	
	private function testComplex1 () {
		var handler:TestHandler = new TestHandler();
		XmlParser.parse('<a><b/><c name="foo"/><d name="bar"><e name="foo"/></d></a>', handler);
		assertEquals(
			"SDSEa{}SEb{}EEb SEc{name=foo }EEc SEd{name=bar }SEe{name=foo }EEe EEd EEa ED",
			handler.log
		);
	}
	
	private function testComplex2 () {
		var handler:TestHandler = new TestHandler();
		XmlParser.parse(
			'<a>\n' +
			'\t<b/>\n' +
			'\t<c name="foo"/>\n' +
			'\t<d name="bar">\n' +
			'\t\t<e name="foo"/>\n' +
			'\t</d>\n' +
			'</a>\n',
			handler
		);
		assertEquals(
			"SDSEa{}CH{\n\t}SEb{}EEb CH{\n\t}SEc{name=foo }EEc CH{\n\t}SEd{name=bar }CH{\n\t\t}" +
			"SEe{name=foo }EEe CH{\n\t}EEd CH{\n}EEa CH{\n}ED",
			handler.log
		);
	}
	
	private function testComplex3 () {
		var handler:TestHandler = new TestHandler();
		XmlParser.parse(
			'<html>\n' +
			'\t<head><title>Bob &#38; Jim&#39;s Fun Page</title></head>\n' +
			'\t<body>\n' +
			'\t\t<![CDATA[15 < 42]]>\n' +
			'\t</body>\n' +
			'</html>\n',
			handler
		);
		assertEquals(
			"SDSEhtml{}CH{\n\t}SEhead{}SEtitle{}CH{Bob }CH{&}CH{ Jim}CH{'}CH{s Fun Page}EEtitle " +
			"EEhead CH{\n\t}SEbody{}CH{\n\t\t}SCCH{15 < 42}ECCH{\n\t}EEbody CH{\n}EEhtml CH{\n}ED",
			handler.log
		);
	}
	
	private function testComplex4 () {
		var handler:TestHandler = new TestHandler();
		XmlParser.parse(
			'<html>\n' +
			'\t<head><title>Bob &amp; Jim&apos;s Fun Page</title></head>\n' +
			'\t<body>\n' +
			'\t\t15 &lt; 42\n' +
			'\t\t<?php print("hello world"); ?>\n' +
			'\t</body>\n' +
			'</html>\n',
			handler
		);
		assertEquals(
			"SDSEhtml{}CH{\n\t}SEhead{}SEtitle{}CH{Bob }CH{&}CH{ Jim}CH{'}CH{s Fun Page}EEtitle " +
			"EEhead CH{\n\t}SEbody{}CH{\n\t\t15 }CH{<}CH{ 42\n\t\t}PIphp{print(" + '"hello world"' +
			"); }CH{\n\t}EEbody CH{\n}EEhtml CH{\n}ED",
			handler.log
		);
	}
	
}

private class TestHandler implements XmlHandler {
	
	public var log:String;
	
	
	public function new () {
		log = "";
	}
	
	public function startDocument () :Void {
		log += "SD";
	}
	
	public function endDocument () :Void {
		log += "ED";
	}
	
	public function startElement (name:String, attributes:Hash<String>) :Void {
		log += "SE";
		log += name;
		log += "{";
		var attrNames:Array<String> = Lambda.array({iterator: function(){return attributes.keys();}}); // FIXME
		attrNames.sort(function (x:String, y:String):Int {
			var i:Int = 0;
			var diff:Int = 0;
			while (diff==0 && i<=x.length && i<=y.length) {
				diff = x.charCodeAt(i) - y.charCodeAt(i);
				++i;
			}
			return diff;
		});
		for (attrName in attrNames) {
			log += attrName + "=" + attributes.get(attrName) + " ";
		}
		log += "}";
	}
	
	public function endElement (name:String) :Void {
		log += "EE" + name + " ";
	}
	
	public function characters (data:String) :Void {
		log += "CH{" + data + "}";
	}
	
	public function processingInstruction (target:String, data:String) :Void {
		log += "PI" + target + "{" + data + "}";
	}
 
	public function comment (data:String) :Void {
		log += "CO{" + data + "}";
	}
	
	public function startCData () :Void {
		log += "SC";
	}
	
	public function endCData () :Void {
		log += "EC";
	}
	
}