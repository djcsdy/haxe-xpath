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
import xpath.expression.Literal;
import xpath.expression.Number;
import xpath.expression.Operation;
import xpath.tokenizer.Token;
import xpath.Operator;


class ExpressionParserTest extends TestCase {
    function testSimpleLiteral() {
        var input = new ParserInput([
            cast(new BeginExpressionToken(), Token),
            new LiteralToken("test123"),
            new EndExpressionToken()
        ]);
        var output = ExpressionParser.getInstance().parse(input);

        assertTrue(output.isComplete());
        assertTrue(Std.is(output.result, Literal));
        assertEquals("test123", Reflect.field(output.result, "value"));
    }

    function testSimpleNumber() {
        var input = new ParserInput([
            cast(new BeginExpressionToken(), Token),
            new NumberToken(123.45),
            new EndExpressionToken()
        ]);
        var output = ExpressionParser.getInstance().parse(input);

        assertTrue(output.isComplete());
        assertTrue(Std.is(output.result, Number));
        assertEquals(123.45, Reflect.field(output.result, "value"));
    }

    function testSimpleOperation() {
        var input = new ParserInput([
            cast(new BeginExpressionToken(), Token),
            new NumberToken(123.45),
            new OperatorToken(Operator.Plus),
            new NumberToken(67.8),
            new EndExpressionToken()
        ]);
        var output = ExpressionParser.getInstance().parse(input);

        assertTrue(output.isComplete());
        assertTrue(Std.is(output.result, Operation));
        var operation = cast(output.result, Operation);
        assertEquals(Operator.Plus, Reflect.field(operation, "operator"));
        assertTrue(Std.is(Reflect.field(operation, "leftOperand"), Number));
        var leftOperand = cast(Reflect.field(operation, "leftOperand"), Number);
        assertEquals(123.45, Reflect.field(leftOperand, "value"));
        assertTrue(Std.is(Reflect.field(operation, "rightOperand"), Number));
        var rightOperand = cast(Reflect.field(operation, "rightOperand"), Number);
        assertEquals(67.8, Reflect.field(rightOperand, "value"));
    }

    function testPrecedence() {
        var input = new ParserInput([
            cast(new BeginExpressionToken(), Token),
            new NumberToken(1),
            new OperatorToken(Operator.Plus),
            new NumberToken(2),
            new OperatorToken(Operator.Multiply),
            new NumberToken(3),
            new EndExpressionToken()
        ]);
        var output = ExpressionParser.getInstance().parse(input);

        assertTrue(output.isComplete());
        assertTrue(Std.is(output.result, Operation));
        var operation = cast(output.result, Operation);
        assertEquals(Operator.Plus, Reflect.field(operation, "operator"));
        assertTrue(Std.is(Reflect.field(operation, "leftOperand"), Number));
        var leftOperand = cast(Reflect.field(operation, "leftOperand"), Number);
        assertEquals(1, Reflect.field(leftOperand, "value"));
        assertTrue(Std.is(Reflect.field(operation, "rightOperand"), Operation));
        operation = Reflect.field(operation, "rightOperand");
        assertTrue(Std.is(Reflect.field(operation, "leftOperand"), Number));
        leftOperand = cast(Reflect.field(operation, "leftOperand"), Number);
        assertEquals(2, Reflect.field(leftOperand, "value"));
        assertTrue(Std.is(Reflect.field(operation, "rightOperand"), Number));
        var rightOperand = cast(Reflect.field(operation, "rightOperand"), Number);
        assertEquals(3, Reflect.field(rightOperand, "value"));
    }
}
