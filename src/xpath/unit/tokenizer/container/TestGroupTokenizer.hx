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


package xpath.unit.tokenizer.container;
import xpath.unit.tokenizer.container._TestContainerTokenizer;
import xpath.unit.tokenizer.container.TestExpressionTokenizer;
import xpath.tokenizer.container.GroupTokenizer;
import xpath.token.Token;
import xpath.token.BeginGroupToken;
import xpath.token.EndGroupToken;
import xpath.token.BeginExpressionToken;
import xpath.token.EndExpressionToken;
import xpath.token.NumberToken;
import xpath.token.BeginFunctionCallToken;
import xpath.token.EndFunctionCallToken;
import xpath.token.OperatorToken;


class TestGroupTokenizer extends _TestContainerTokenizer {
	
	public function new () {
		super(GroupTokenizer.getInstance());
	}
	
	private function testNumber () {
		doGoodTest("(123)", [
			cast(new BeginGroupToken(), Token), new BeginExpressionToken(), new NumberToken(123),
			new EndExpressionToken(), new EndGroupToken()
		]);
	}
	
	private function testFunction () {
		doGoodTest("(foo())", [
			cast(new BeginGroupToken(), Token), new BeginExpressionToken(),
			new BeginFunctionCallToken("foo"), new EndFunctionCallToken(),
			new EndExpressionToken(), new EndGroupToken()
		]);
	}
	
	private function testOperation () {
		doGoodTest("((1+2)*3)", [
			cast(new BeginGroupToken(), Token), new BeginExpressionToken(), new BeginGroupToken(),
			new BeginExpressionToken(), new NumberToken(1), new OperatorToken(Plus),
			new NumberToken(2), new EndExpressionToken(), new EndGroupToken(),
			new OperatorToken(Multiply), new NumberToken(3), new EndExpressionToken(),
			new EndGroupToken()
		]);
	}
		
	private function testJunk () {
		doBadTest("()");
		doBadTest("(8+7");
		doBadTest("");
		doBadTest("/a/b");
	}
	
}