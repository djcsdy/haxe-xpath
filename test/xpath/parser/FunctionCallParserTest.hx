package xpath.parser;

import xpath.expression.Expression;
import xpath.expression.FunctionCall;
import xpath.expression.VariableReference;
import xpath.tokenizer.Token;
import xpath.tokenizer.Token.BeginFunctionCallToken;
import haxe.unit.TestCase;

class FunctionCallParserTest extends TestCase {
    function testVariable() {
        var input = new ParserInput([
            cast(new BeginFunctionCallToken("kittens"), Token),
            new BeginExpressionToken(),
            new VariableReferenceToken("chocolate"),
            new EndExpressionToken(),
            new EndFunctionCallToken()
        ]);

        var output = FunctionCallParser.getInstance().parse(input);

        assertTrue(output.isComplete());
        assertTrue(Std.is(output.result, FunctionCall));
        assertEquals("kittens", Reflect.field(output.result, "name"));

        var parameters = Lambda.array(Reflect.field(output.result, "parameters"));
        assertEquals(1, parameters.length);
        assertTrue(Std.is(parameters[0], VariableReference));
        assertEquals("chocolate", Reflect.field(parameters[0], "name"));
    }
}
