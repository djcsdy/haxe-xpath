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


package xpath.parser;
import haxe.unit.TestCase;
import xpath.expression.RootStep;
import xpath.expression.TypeStep;
import xpath.expression.AxisStep;
import xpath.tokenizer.Token;
import xpath.Axis;
import xpath.NodeCategory;


class PathParserTest extends TestCase {
    function testRoot() {
        var input = new ParserInput([
            cast(new BeginPathToken(), Token),
            new StepDelimiterToken(),
            new EndPathToken()
        ]);
        var output = PathParser.getInstance().parse(input);

        assertTrue(output.isComplete());
        assertTrue(Std.is(output.result, RootStep));
        assertEquals(null, Reflect.field(output.result, "nextStep"));
    }

    function testSelf() {
        var input = new ParserInput([
            cast(new BeginPathToken(), Token),
            new AxisToken(Axis.Self),
            new TypeTestToken(NodeCategory.Node),
            new EndPathToken()
        ]);
        var output = PathParser.getInstance().parse(input);

        assertTrue(output.isComplete());
        assertTrue(Std.is(output.result, TypeStep));
        assertEquals(null, Reflect.field(output.result, "nextStep"));
    }

    function testRootSelf() {
        var input = new ParserInput([
            cast(new BeginPathToken(), Token),
            new StepDelimiterToken(),
            new AxisToken(Axis.Self),
            new TypeTestToken(NodeCategory.Node),
            new EndPathToken()
        ]);
        var output = PathParser.getInstance().parse(input);

        assertTrue(output.isComplete());
        assertTrue(Std.is(output.result, RootStep));
        assertEquals(null, Reflect.field(output.result, "nextStep"));
    }

    function testChildChild() {
        var input = new ParserInput([
            cast(new BeginPathToken(), Token),
            new AxisToken(Axis.Child),
            new TypeTestToken(NodeCategory.Node),
            new StepDelimiterToken(),
            new AxisToken(Axis.Child),
            new TypeTestToken(NodeCategory.Node),
            new EndPathToken()
        ]);
        var output = PathParser.getInstance().parse(input);

        assertTrue(output.isComplete());
        assertTrue(Std.is(output.result, AxisStep));
        assertEquals(Axis.Child, Reflect.field(output.result, "axis"));
        assertTrue(Std.is(Reflect.field(output.result, "nextStep"), AxisStep));
        var next = cast(Reflect.field(output.result, "nextStep"), AxisStep);
        assertEquals(Axis.Child, Reflect.field(next, "axis"));
        assertEquals(null, Reflect.field(next, "nextStep"));
    }
}
