/* haXe XPath by Daniel J. Cassidy <mail@danielcassidy.me.uk>
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


package xpath.unit.tokenizer.container;
import haxe.unit.TestCase;
import xpath.tokenizer.Tokenizer;
import xpath.tokenizer.TokenizeState;
import xpath.token.Token;


class _TestContainerTokenizer extends TestCase {
	
	private var tokenizer:Tokenizer;
	
	
	private function new (tokenizer:Tokenizer) {
		super();
		this.tokenizer = tokenizer;
	}
	
	private function doGoodTest (xpathStr:String, expectedResult:Array<Token>) {
		var state:TokenizeState = new TokenizeState(xpathStr);
		state = tokenizer.tokenize(state);
		
		assertEquals(xpathStr.length, state.pos);
		assertEquals(expectedResult.length, state.result.length);
		for (i in 0...state.result.length) {
			assertEquals(Type.getClass(expectedResult[i]), Type.getClass(state.result[i]));
			for (field in Reflect.fields(expectedResult[i])) {
				assertEquals(
					Reflect.field(expectedResult[i], field), Reflect.field(state.result[i], field)
				);
			}
		}
	}
	
	private function doBadTest (xpathStr:String) {
		var state:TokenizeState = new TokenizeState(xpathStr);
		state = tokenizer.tokenize(state);
		
		assertEquals(null, state.result);
		assertEquals(0, state.pos);
	}
	
	private function doIncompleteTest (xpathStr:String) {
		var state:TokenizeState = new TokenizeState(xpathStr);
		state = tokenizer.tokenize(state);
		
		assertTrue(state.pos < xpathStr.length);
	}
	
}	