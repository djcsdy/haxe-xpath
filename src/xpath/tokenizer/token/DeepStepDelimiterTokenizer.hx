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


package xpath.tokenizer.token;
import xpath.tokenizer.token.TokenTokenizer;
import xpath.tokenizer.Tokenizer;
import xpath.tokenizer.TokenizeState;
import xpath.token.Token;
import xpath.token.StepDelimiterToken;
import xpath.token.AxisToken;
import xpath.token.TypeTestToken;


class DeepStepDelimiterTokenizer extends TokenTokenizer {
	
	private static var instance:DeepStepDelimiterTokenizer;
	
	
	public static function getInstance () :DeepStepDelimiterTokenizer {
		if (instance == null) instance = new DeepStepDelimiterTokenizer();
		return instance;
	}
	
	private function new () {
	}
	
	override public function tokenize (state:TokenizeState) :TokenizeState {
		var resultState:TokenizeState = state.newWorkingCopy();
		var pos:Int = resultState.pos;
		
		// check for '//'
		if (resultState.xpathStr.substr(pos, 2) == "//") {
			// succeed
			resultState.pos = skipWhitespace(resultState.xpathStr, pos+2);
			resultState.result = [
				cast(new StepDelimiterToken(), Token), new AxisToken(DescendantOrSelf),
				new TypeTestToken(Node), new StepDelimiterToken()
			];
		} // else fail
		
		return resultState;
	}
	
}