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


package xpath.library;
import haxe.unit.TestCase;
import xpath.library.NumberLibrary;
import xpath.context.FakeContext;
import xpath.value.XPathValue;
import xpath.value.XPathBoolean;
import xpath.value.XPathNumber;
import xpath.value.XPathString;
import xpath.value.XPathNodeSet;
import xpath.xml.XPathXml;
import xpath.xml.XPathHxXml;
import xpath.EvaluationException;


class NumberLibraryTest extends TestCase {

    function testSum() {
        var context = new FakeContext();
        var caught = false;
        try {
            NumberLibrary.sum(context, []);
        } catch (exception:EvaluationException) {
            caught = true;
        }
        assertTrue(caught);

        var nodeSet:XPathValue = new XPathNodeSet([
            cast(XPathHxXml.wrapNode(Xml.createCData("1")), XPathXml),
            XPathHxXml.wrapNode(Xml.createCData("2")),
            XPathHxXml.wrapNode(Xml.createCData("3"))
        ]);
        var result = NumberLibrary.sum(context, [nodeSet]);
        assertEquals(6., result.getFloat());

        var complicatedNode = Xml.createElement("foo");
        complicatedNode.addChild(Xml.createCData("1"));
        var complicatedChild = Xml.createElement("bar");
        complicatedNode.addChild(complicatedChild);
        complicatedChild.addChild(Xml.createCData("2"));
        nodeSet = new XPathNodeSet([
            cast(XPathHxXml.wrapNode(complicatedNode), XPathXml),
            XPathHxXml.wrapNode(Xml.createCData("3"))
        ]);
        result = NumberLibrary.sum(context, [nodeSet]);
        assertEquals(15., result.getFloat());

        caught = false;
        try {
            NumberLibrary.sum(context, [nodeSet, new XPathNodeSet([])]);
        } catch (exception:EvaluationException) {
            caught = true;
        }
        assertTrue(caught);

        caught = false;
        try {
            NumberLibrary.sum(context, [cast(new XPathBoolean(), XPathValue)]);
        } catch (exception:EvaluationException) {
            caught = true;
        }
        assertTrue(caught);
    }

    function testFloor() {
        var context = new FakeContext();
        var value:XPathValue = new XPathBoolean(true);
        var result = NumberLibrary.floor(context, [value]);
        assertEquals(1., result.getFloat());

        value = new XPathBoolean(false);
        result = NumberLibrary.floor(context, [value]);
        assertEquals(0., result.getFloat());

        value = new XPathNumber(12.8);
        result = NumberLibrary.floor(context, [value]);
        assertEquals(12., result.getFloat());

        value = new XPathNumber(14.23);
        result = NumberLibrary.floor(context, [value]);
        assertEquals(14., result.getFloat());

        value = new XPathString("3.14159");
        result = NumberLibrary.floor(context, [value]);
        assertEquals(3., result.getFloat());

        var complicatedNode = Xml.createElement("foo");
        complicatedNode.addChild(Xml.createCData("1"));
        var complicatedChild = Xml.createElement("bar");
        complicatedNode.addChild(complicatedChild);
        complicatedChild.addChild(Xml.createCData("2.345"));
        value = new XPathNodeSet([
            cast(XPathHxXml.wrapNode(complicatedNode), XPathXml),
            XPathHxXml.wrapNode(Xml.createCData("3598"))
        ]);
        result = NumberLibrary.floor(context, [value]);
        assertEquals(12., result.getFloat());

        var caught = false;
        try {
            NumberLibrary.floor(context, []);
        } catch (exception:EvaluationException) {
            caught = true;
        }
        assertTrue(caught);

        caught = false;
        try {
            NumberLibrary.floor(context, [value, new XPathBoolean()]);
        } catch (exception:EvaluationException) {
            caught = true;
        }
        assertTrue(caught);
    }

    function testCeiling() {
        var context = new FakeContext();
        var value:XPathValue = new XPathBoolean(true);
        var result = NumberLibrary.ceiling(context, [value]);
        assertEquals(1., result.getFloat());

        value = new XPathBoolean(false);
        result = NumberLibrary.ceiling(context, [value]);
        assertEquals(0., result.getFloat());

        value = new XPathNumber(12.8);
        result = NumberLibrary.ceiling(context, [value]);
        assertEquals(13., result.getFloat());

        value = new XPathNumber(14.23);
        result = NumberLibrary.ceiling(context, [value]);
        assertEquals(15., result.getFloat());

        value = new XPathString("3.14159");
        result = NumberLibrary.ceiling(context, [value]);
        assertEquals(4., result.getFloat());

        var complicatedNode = Xml.createElement("foo");
        complicatedNode.addChild(Xml.createCData("1"));
        var complicatedChild = Xml.createElement("bar");
        complicatedNode.addChild(complicatedChild);
        complicatedChild.addChild(Xml.createCData("2.345"));
        value = new XPathNodeSet([
            cast(XPathHxXml.wrapNode(complicatedNode), XPathXml),
            XPathHxXml.wrapNode(Xml.createCData("3598"))
        ]);
        result = NumberLibrary.ceiling(context, [value]);
        assertEquals(13., result.getFloat());

        var caught = false;
        try {
            NumberLibrary.ceiling(context, []);
        } catch (exception:EvaluationException) {
            caught = true;
        }
        assertTrue(caught);

        caught = false;
        try {
            NumberLibrary.ceiling(context, [value, new XPathBoolean()]);
        } catch (exception:EvaluationException) {
            caught = true;
        }
        assertTrue(caught);
    }

    function testRound() {
        var context = new FakeContext();
        var value:XPathValue = new XPathBoolean(true);
        var result = NumberLibrary.round(context, [value]);
        assertEquals(1., result.getFloat());

        value = new XPathBoolean(false);
        result = NumberLibrary.round(context, [value]);
        assertEquals(0., result.getFloat());

        value = new XPathNumber(12.8);
        result = NumberLibrary.round(context, [value]);
        assertEquals(13., result.getFloat());

        value = new XPathNumber(14.23);
        result = NumberLibrary.round(context, [value]);
        assertEquals(14., result.getFloat());

        value = new XPathString("3.14159");
        result = NumberLibrary.round(context, [value]);
        assertEquals(3., result.getFloat());

        var complicatedNode = Xml.createElement("foo");
        complicatedNode.addChild(Xml.createCData("1"));
        var complicatedChild = Xml.createElement("bar");
        complicatedNode.addChild(complicatedChild);
        complicatedChild.addChild(Xml.createCData("2.345"));
        value = new XPathNodeSet([
            cast(XPathHxXml.wrapNode(complicatedNode), XPathXml),
            XPathHxXml.wrapNode(Xml.createCData("3598"))
        ]);
        result = NumberLibrary.round(context, [value]);
        assertEquals(12., result.getFloat());

        var caught = false;
        try {
            NumberLibrary.round(context, []);
        } catch (exception:EvaluationException) {
            caught = true;
        }
        assertTrue(caught);

        caught = false;
        try {
            NumberLibrary.round(context, [value, new XPathBoolean()]);
        } catch (exception:EvaluationException) {
            caught = true;
        }
        assertTrue(caught);
    }
}
