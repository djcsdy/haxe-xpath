/* haXe XPath by Daniel J. Cassidy <mail@danielcassidy.me.uk>
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


package xpath.unit.parser;
import haxe.unit.TestCase;
import xpath.parser.ParseState;
import xpath.token.Token;
import xpath.token.AxisToken;
import xpath.token.NameTestToken;
import xpath.token.StepDelimiterToken;
import xpath.expression.PathStep;
import xpath.expression.AxisStep;
import xpath.expression.NameStep;


class TestParseState extends TestCase {

	private function testNew () {
		var a:AxisToken = new AxisToken(Child);
		var b:NameTestToken = new NameTestToken("div");
		var c:StepDelimiterToken = new StepDelimiterToken();
		var d:AxisToken = new AxisToken(Descendant);
		var e:NameTestToken = new NameTestToken("p");
		var tokens:Array<Token> = [ cast(a, Token), b, c, d, e ];
		
		var parseState:ParseState = new ParseState(tokens);
		assertEquals(tokens, parseState.tokens);
		assertEquals(0, parseState.pos);
		assertEquals(null, parseState.result);
	}
	
	private function testPos () {
		var a:AxisToken = new AxisToken(Child);
		var b:NameTestToken = new NameTestToken("div");
		var c:StepDelimiterToken = new StepDelimiterToken();
		var d:AxisToken = new AxisToken(Descendant);
		var e:NameTestToken = new NameTestToken("p");
		var tokens:Array<Token> = [ cast(a, Token), b, c, d, e ];
		
		var parseState:ParseState = new ParseState(tokens);
		for (i in 0...tokens.length+1) {
			parseState.pos = i;
			assertEquals(i, parseState.pos);
		}
		parseState.pos = tokens.length + 1;
		assertEquals(null, parseState.pos);
		parseState.pos = -1;
		assertEquals(null, parseState.pos);
	}

	private function testNewWorkingCopy () {
		var a:AxisToken = new AxisToken(Child);
		var b:NameTestToken = new NameTestToken("div");
		var c:StepDelimiterToken = new StepDelimiterToken();
		var d:AxisToken = new AxisToken(Descendant);
		var e:NameTestToken = new NameTestToken("p");
		var tokens:Array<Token> = [ cast(a, Token), b, c, d, e ];
		
		var v:PathStep = new NameStep("p");
		var u:PathStep = new AxisStep(Descendant, v);
		var t:PathStep = new NameStep("div", u);
		var s:PathStep = new AxisStep(Child, t);
		
		var parseState:ParseState = new ParseState(tokens);
		parseState.pos = 3;
		parseState.result = s;
		
		var newParseState:ParseState = parseState.newWorkingCopy();
		assertEquals(parseState.tokens, newParseState.tokens);
		assertEquals(parseState.pos, newParseState.pos);
		assertEquals(null, newParseState.result);
	}
	
}
