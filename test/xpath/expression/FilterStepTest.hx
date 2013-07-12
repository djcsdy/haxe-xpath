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


package xpath.expression;
import haxe.unit.TestCase;
import xpath.context.FakeContext;
import xpath.value.XPathNodeSet;
import xpath.xml.XPathXml;
import xpath.xml.XPathHxXml;
import xpath.EvaluationException;


class FilterStepTest extends TestCase {
    function testFilterStep() {
        var nodeSet = [
            cast(XPathHxXml.wrapNode(Xml.createElement("a")), XPathXml),
            XPathHxXml.wrapNode(Xml.createElement("b"))
        ];
        var filterStep = new FilterStep(new FakeNodeSetExpression(nodeSet));
        var result = filterStep.evaluate(new FakeContext());
        var nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
        assertEquals(nodeSet.length, nodes.length);
        for (i in 0...nodes.length) {
            assertEquals(nodeSet[i], nodes[i]);
        }

        var caught = false;
        try {
            filterStep = new FilterStep(new Literal("foo"));
            result = filterStep.evaluate(new FakeContext());
        } catch (e:EvaluationException) {
            caught = true;
        }
        assertTrue(caught);

        caught = false;
        try {
            filterStep = new FilterStep(new Number(123));
            result = filterStep.evaluate(new FakeContext());
        } catch (e:EvaluationException) {
            caught = true;
        }
        assertTrue(caught);

        var caught = false;
        try {
            var filterStep = new FilterStep(new FakeBooleanExpression(true));
            var result = filterStep.evaluate(new FakeContext());
        } catch (e:EvaluationException) {
            caught = true;
        }
        assertTrue(caught);
    }
}
