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


package xpath.tokenizer.token;
import xpath.tokenizer.token.TokenTokenizer;
import xpath.tokenizer.Tokenizer;
import xpath.tokenizer.TokenizeState;
import xpath.token.Token;
import xpath.token.NumberToken;


class NumberTokenizer extends TokenTokenizer {
	
	private static var instance:NumberTokenizer;
	
	
	public static function getInstance () :NumberTokenizer {
		if (instance == null) instance = new NumberTokenizer();
		return instance;
	}
	
	private function new () {
	}
	
	override public function tokenize (state:TokenizeState) :TokenizeState {
		var resultState:TokenizeState = state.newWorkingCopy();
		var pos:Int = resultState.pos;
		var charCode:Int;
		
		// check for digits before decimal point
		var numberStartPos = pos--;
		do {
			charCode = resultState.xpathStr.charCodeAt(++pos);
		} while (charCode > 47 && charCode < 58);
		
		// check for decimal point
		if (charCode != 46) {
			if (pos > numberStartPos) {
				var value:Float = Std.parseFloat(resultState.xpathStr.substr(numberStartPos, pos - numberStartPos));
				resultState.result = [cast(new NumberToken(value), Token)];
				resultState.pos = skipWhitespace(resultState.xpathStr, pos);
			} // else fail
			
			return resultState;
		}
		
		// check for digits after decimal point
		do {
			charCode = resultState.xpathStr.charCodeAt(++pos);
		} while (charCode > 47 && charCode < 58);
		
		if (pos > numberStartPos + 1) {
			var value:Float = Std.parseFloat(resultState.xpathStr.substr(numberStartPos, pos - numberStartPos));
			resultState.result = [cast(new NumberToken(value), Token)];
			resultState.pos = skipWhitespace(resultState.xpathStr, pos);
		} // else fail
		
		return resultState;
	}
	
}