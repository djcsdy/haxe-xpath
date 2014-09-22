/* Haxe XPath by Daniel J. Cassidy <mail@danielcassidy.me.uk>
 * Dedicated to the Public Domain
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS 
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


package xpath;
import xpath.xml.XPathXml;
import xpath.value.XPathNodeSet;
import xpath.value.XPathString;
import xpath.context.Context;
import xpath.value.XPathValue;
import xpath.context.DynamicEnvironment;
import haxe.unit.TestCase;
import xpath.tokenizer.TokenizerException;
import xpath.value.XPathBoolean;
import xpath.value.XPathNumber;
import xpath.xml.XPathHxXml;


class XPathTest extends TestCase {
    /* <a>
     *     <b/>
     *     <c name="foo"/>
     *     <d name="bar">
     *         <e name="foo"/>
     *     </d>
     * </a> */
    var xml:Xml;
    var a:Xml;
    var b:Xml;
    var c:Xml;
    var d:Xml;
    var e:Xml;


    public function new() {
        super();

        xml = Xml.createDocument();
        a = Xml.createElement("a");
        b = Xml.createElement("b");
        c = Xml.createElement("c");
        d = Xml.createElement("d");
        e = Xml.createElement("e");

        c.set("name", "foo");
        d.set("name", "bar");
        e.set("name", "foo");

        xml.addChild(a);
        a.addChild(b);
        a.addChild(c);
        a.addChild(d);
        d.addChild(e);
    }

    function testOneStep() {
        var xpathXml = XPathHxXml.wrapNode(xml);
        var xpathQry = new XPath("node()");
        var nodes = Lambda.array(xpathQry.selectNodes(xpathXml));
        assertEquals(1, nodes.length);
        assertEquals(a, cast(nodes[0], XPathHxXml).getWrappedXml());

        xpathQry = new XPath("descendant::node()");
        nodes = Lambda.array(xpathQry.selectNodes(xpathXml));
        assertEquals(5, nodes.length);
        assertEquals(a, cast(nodes[0], XPathHxXml).getWrappedXml());
        assertEquals(b, cast(nodes[1], XPathHxXml).getWrappedXml());
        assertEquals(c, cast(nodes[2], XPathHxXml).getWrappedXml());
        assertEquals(d, cast(nodes[3], XPathHxXml).getWrappedXml());
        assertEquals(e, cast(nodes[4], XPathHxXml).getWrappedXml());
    }

    function testTwoStep() {
        var xpathE = XPathHxXml.wrapNode(e);
        var xpathQry = new XPath("/node()");
        var nodes = Lambda.array(xpathQry.selectNodes(xpathE));
        assertEquals(1, nodes.length);
        assertEquals(a, cast(nodes[0], XPathHxXml).getWrappedXml());
    }

    function testDeepStep() {
        var xpathB = XPathHxXml.wrapNode(b);
        var xpathQry = new XPath("//node()");
        var nodes = Lambda.array(xpathQry.selectNodes(xpathB));
        assertEquals(5, nodes.length);
        assertEquals(a, cast(nodes[0], XPathHxXml).getWrappedXml());
        assertEquals(b, cast(nodes[1], XPathHxXml).getWrappedXml());
        assertEquals(c, cast(nodes[2], XPathHxXml).getWrappedXml());
        assertEquals(d, cast(nodes[3], XPathHxXml).getWrappedXml());
        assertEquals(e, cast(nodes[4], XPathHxXml).getWrappedXml());
    }

    function testRoot() {
        var xpathB = XPathHxXml.wrapNode(b);
        var xpathQry = new XPath("/");
        var nodes = Lambda.array(xpathQry.selectNodes(xpathB));
        assertEquals(1, nodes.length);
        assertEquals(xml, cast(nodes[0], XPathHxXml).getWrappedXml());
    }

    function testAbbreviatedStep1() {
        var xpathA = XPathHxXml.wrapNode(a);
        var xpathQry = new XPath(".");
        var nodes = Lambda.array(xpathQry.selectNodes(xpathA));
        assertEquals(1, nodes.length);
        assertEquals(a, cast(nodes[0], XPathHxXml).getWrappedXml());
    }

    function testAbbreviatedStep2() {
        var xpathA = XPathHxXml.wrapNode(a);
        var xpathQry = new XPath("..");
        var nodes = Lambda.array(xpathQry.selectNodes(xpathA));
        assertEquals(1, nodes.length);
        assertEquals(xml, cast(nodes[0], XPathHxXml).getWrappedXml());
    }

    function testPredicate1() {
        var xpathA = XPathHxXml.wrapNode(a);
        var xpathQry = new XPath("node()[1]");
        var nodes = Lambda.array(xpathQry.selectNodes(xpathA));
        assertEquals(1, nodes.length);
        assertEquals(b, cast(nodes[0], XPathHxXml).getWrappedXml());
    }

    function testPredicate2() {
        var xpathA = XPathHxXml.wrapNode(a);
        var xpathQry = new XPath("node()[3]");
        var nodes = Lambda.array(xpathQry.selectNodes(xpathA));
        assertEquals(1, nodes.length);
        assertEquals(d, cast(nodes[0], XPathHxXml).getWrappedXml());
    }

    function testDeepStepPredicate() {
        var xpathC = XPathHxXml.wrapNode(c);
        var xpathQry = new XPath("//node()[1]");
        var nodes = Lambda.array(xpathQry.selectNodes(xpathC));
        assertEquals(3, nodes.length);
        assertEquals(a, cast(nodes[0], XPathHxXml).getWrappedXml());
        assertEquals(b, cast(nodes[1], XPathHxXml).getWrappedXml());
        assertEquals(e, cast(nodes[2], XPathHxXml).getWrappedXml());
    }

    function testGroup() {
        var xpathC = XPathHxXml.wrapNode(c);
        var xpathQry = new XPath("(//node()[1])");
        var nodes = Lambda.array(xpathQry.selectNodes(xpathC));
        assertEquals(3, nodes.length);
        assertEquals(a, cast(nodes[0], XPathHxXml).getWrappedXml());
        assertEquals(b, cast(nodes[1], XPathHxXml).getWrappedXml());
        assertEquals(e, cast(nodes[2], XPathHxXml).getWrappedXml());
    }

    function testGroupPredicate() {
        var xpathC = XPathHxXml.wrapNode(c);
        var xpathQry = new XPath("(//node()[1])[3]");
        var nodes = Lambda.array(xpathQry.selectNodes(xpathC));
        assertEquals(1, nodes.length);
        assertEquals(e, cast(nodes[0], XPathHxXml).getWrappedXml());
    }

    function testFunction() {
        var xpathXml = XPathHxXml.wrapNode(xml);
        var xpathQry = new XPath("true()");
        var result = xpathQry.evaluate(xpathXml);
        assertTrue(Std.is(result, XPathBoolean));
        assertTrue(result.getBool());
    }

    function testFunctionCallVariable() {
        var contextNode: XPathXml = XPathHxXml.wrapNode(a);
        var xpath = new XPath("kittens($chocolate)");

        var contextPassedToFunction:Context = null;
        var argumentsPassedToFunction: Array<XPathValue> = null;
        var functionResultNode:XPathXml = XPathHxXml.wrapNode(e);

        var environment = new DynamicEnvironment();

        environment.setFunction("kittens", function (context: Context, arguments:Array<XPathValue>): XPathValue {
            contextPassedToFunction = context;
            argumentsPassedToFunction = arguments;
            return new XPathNodeSet([functionResultNode]);
        });

        environment.setVariable("chocolate", new XPathString("cup of tea"));

        var result = xpath.evaluate(contextNode, environment);
        assertTrue(Std.is(result, XPathNodeSet));
        var resultArray = Lambda.array(cast(result, XPathNodeSet).getNodes());

        assertEquals(1, resultArray.length);
        assertEquals(functionResultNode, resultArray[0]);
        assertEquals(contextNode, contextPassedToFunction.node);
        assertEquals(0, contextPassedToFunction.position);
        assertEquals(1, contextPassedToFunction.size);
        assertEquals(1, argumentsPassedToFunction.length);
        assertTrue(Std.is(argumentsPassedToFunction[0], XPathString));
        assertEquals("cup of tea", cast(argumentsPassedToFunction[0], XPathString).getString());
    }

    function testOperation1() {
        var xpathXml = XPathHxXml.wrapNode(xml);
        var xpathQry = new XPath("1 + 1");
        var result = xpathQry.evaluate(xpathXml);
        assertTrue(Std.is(result, XPathNumber));
        assertEquals(2.0, result.getFloat());
    }

    function testOperation2() {
        var xpathXml = XPathHxXml.wrapNode(xml);
        var xpathQry = new XPath("1+1 = 2");
        var result = xpathQry.evaluate(xpathXml);
        assertTrue(Std.is(result, XPathBoolean));
        assertTrue(result.getBool());
    }

    function testOperation3() {
        var xpathXml = XPathHxXml.wrapNode(xml);
        var xpathQry = new XPath("1+2 *3 = 7");
        var result = xpathQry.evaluate(xpathXml);
        assertTrue(Std.is(result, XPathBoolean));
        assertTrue(result.getBool());
    }

    function testComplex1() {
        var xpathXml = XPathHxXml.wrapNode(xml);
        var xpathQry = new XPath("//node()[@name='foo']");
        var nodes = Lambda.array(xpathQry.selectNodes(xpathXml));
        assertEquals(2, nodes.length);
        assertEquals(c, cast(nodes[0], XPathHxXml).getWrappedXml());
        assertEquals(e, cast(nodes[1], XPathHxXml).getWrappedXml());
    }

    function testComplex2() {
        var xpathXml = XPathHxXml.wrapNode(xml);
        var xpathQry = new XPath("//node()[@name='foo'][../@name='bar']");
        var nodes = Lambda.array(xpathQry.selectNodes(xpathXml));
        assertEquals(1, nodes.length);
        assertEquals(e, cast(nodes[0], XPathHxXml).getWrappedXml());
    }

    function testComplex3() {
        var xpathXml = XPathHxXml.wrapNode(xml);
        var xpathQry = new XPath("//node()[@name='foo' and ../@name='bar']");
        var nodes = Lambda.array(xpathQry.selectNodes(xpathXml));
        assertEquals(1, nodes.length);
        assertEquals(e, cast(nodes[0], XPathHxXml).getWrappedXml());
    }

    function testSyntaxError() {
        var caught = false;
        try {
            new XPath("1++1");
        } catch (e:TokenizerException) {
            caught = true;
        }
        assertTrue(caught);
    }
}
