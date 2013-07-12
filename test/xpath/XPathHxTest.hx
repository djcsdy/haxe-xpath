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
import haxe.unit.TestCase;
import xpath.tokenizer.TokenizerException;


class XPathHxTest extends TestCase {
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
        var xpathQry = new XPathHx("node()");
        var nodes = Lambda.array(xpathQry.selectNodes(xml));
        assertEquals(1, nodes.length);
        assertEquals(a, nodes[0]);

        xpathQry = new XPathHx("descendant::node()");
        nodes = Lambda.array(xpathQry.selectNodes(xml));
        assertEquals(5, nodes.length);
        assertEquals(a, nodes[0]);
        assertEquals(b, nodes[1]);
        assertEquals(c, nodes[2]);
        assertEquals(d, nodes[3]);
        assertEquals(e, nodes[4]);
    }

    function testTwoStep() {
        var xpathQry = new XPathHx("/node()");
        var nodes = Lambda.array(xpathQry.selectNodes(e));
        assertEquals(1, nodes.length);
        assertEquals(a, nodes[0]);
    }

    function testDeepStep() {
        var xpathQry = new XPathHx("//node()");
        var nodes = Lambda.array(xpathQry.selectNodes(b));
        assertEquals(5, nodes.length);
        assertEquals(a, nodes[0]);
        assertEquals(b, nodes[1]);
        assertEquals(c, nodes[2]);
        assertEquals(d, nodes[3]);
        assertEquals(e, nodes[4]);
    }

    /* Currently broken on Flash 9 due to a *very* obscure issue.
     * TODO: fix
    function testRoot () {
        var xpathQry = new XPathHx("/");
        var nodes = Lambda.array(xpathQry.selectNodes(b));
        assertEquals(1, nodes.length);
        assertEquals(xml, nodes[0]);
    }*/

    /* Currently broken on Flash 9 due to a *very* obscure issue.
     * TODO: fix
    function testAbbreviatedStep1 () {
        var xpathQry = new XPathHx(".");
        var nodes = Lambda.array(xpathQry.selectNodes(a));
        assertEquals(1, nodes.length);
        assertEquals(a, nodes[0]);
    }*/

    function testAbbreviatedStep2() {
        var xpathQry = new XPathHx("..");
        var nodes = Lambda.array(xpathQry.selectNodes(a));
        assertEquals(1, nodes.length);
        assertEquals(xml, nodes[0]);
    }

    function testPredicate1() {
        var xpathQry = new XPathHx("node()[1]");
        var nodes = Lambda.array(xpathQry.selectNodes(a));
        assertEquals(1, nodes.length);
        assertEquals(b, nodes[0]);
    }

    function testPredicate2() {
        var xpathQry = new XPathHx("node()[3]");
        var nodes = Lambda.array(xpathQry.selectNodes(a));
        assertEquals(1, nodes.length);
        assertEquals(d, nodes[0]);
    }

    function testDeepStepPredicate() {
        var xpathQry = new XPathHx("//node()[1]");
        var nodes = Lambda.array(xpathQry.selectNodes(c));
        assertEquals(3, nodes.length);
        assertEquals(a, nodes[0]);
        assertEquals(b, nodes[1]);
        assertEquals(e, nodes[2]);
    }

    function testGroup() {
        var xpathQry = new XPathHx("(//node()[1])");
        var nodes = Lambda.array(xpathQry.selectNodes(c));
        assertEquals(3, nodes.length);
        assertEquals(a, nodes[0]);
        assertEquals(b, nodes[1]);
        assertEquals(e, nodes[2]);
    }

    function testGroupPredicate() {
        var xpathQry = new XPathHx("(//node()[1])[3]");
        var nodes = Lambda.array(xpathQry.selectNodes(c));
        assertEquals(1, nodes.length);
        assertEquals(e, nodes[0]);
    }

    function testFunction() {
        var xpathQry = new XPathHx("true()");

        var result = xpathQry.evaluateAsBool(xml);
        assertTrue(result);

        var caught = false;
        try {
            xpathQry.selectNodes(xml);
        } catch (ex:EvaluationException) {
            caught = true;
        }
        assertTrue(caught);
    }

    function testOperation1() {
        var xpathQry = new XPathHx("1 + 1");
        var result = xpathQry.evaluateAsFloat(xml);
        assertEquals(2.0, result);

        var caught = false;
        try {
            xpathQry.selectNodes(xml);
        } catch (ex:EvaluationException) {
            caught = true;
        }
        assertTrue(caught);
    }

    function testOperation2() {
        var xpathQry = new XPathHx("1+1 = 2");
        var result = xpathQry.evaluateAsBool(xml);
        assertTrue(result);

        var caught = false;
        try {
            xpathQry.selectNodes(xml);
        } catch (ex:EvaluationException) {
            caught = true;
        }
        assertTrue(caught);
    }

    function testOperation3() {
        var xpathQry = new XPathHx("1+2 *3 = 7");
        var result = xpathQry.evaluateAsBool(xml);
        assertTrue(result);

        var caught = false;
        try {
            xpathQry.selectNodes(xml);
        } catch (ex:EvaluationException) {
            caught = true;
        }
        assertTrue(caught);
    }

    function testComplex1() {
        var xpathQry = new XPathHx("//node()[@name='foo']");
        var nodes = Lambda.array(xpathQry.selectNodes(xml));
        assertEquals(2, nodes.length);
        assertEquals(c, nodes[0]);
        assertEquals(e, nodes[1]);
    }

    function testComplex2() {
        var xpathQry = new XPathHx("//node()[@name='foo'][../@name='bar']");
        var nodes = Lambda.array(xpathQry.selectNodes(xml));
        assertEquals(1, nodes.length);
        assertEquals(e, nodes[0]);
    }

    function testComplex3() {
        var xpathQry = new XPathHx("//node()[@name='foo' and ../@name='bar']");
        var nodes = Lambda.array(xpathQry.selectNodes(xml));
        assertEquals(1, nodes.length);
        assertEquals(e, nodes[0]);
    }

    function testSyntaxError() {
        var caught = false;
        try {
            new XPathHx("1++1");
        } catch (e:TokenizerException) {
            caught = true;
        }
        assertTrue(caught);
    }
}
