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


package xpath.tokenizer.container;
import xpath.tokenizer.Tokenizer;
import xpath.tokenizer.TokenizeState;
import xpath.tokenizer.util.Sequence;
import xpath.tokenizer.util.Repetition;
import xpath.tokenizer.container.FilterOperandTokenizer;
import xpath.tokenizer.token.BeginExpressionTokenizer;
import xpath.tokenizer.token.NegationOperatorTokenizer;
import xpath.tokenizer.token.EndExpressionTokenizer;


class FilterExpressionTokenizer implements Tokenizer {
	
	private static var instance:FilterExpressionTokenizer;
	
	private var tokenizer:Tokenizer;
	
	
	public static function getInstance () :FilterExpressionTokenizer {
		if (instance == null) {
			instance = new FilterExpressionTokenizer();
			instance.init();
		}
		return instance;
	}
	
	private function new () {
	}
	
	private function init () :Void {
		tokenizer = new Sequence([
			cast(BeginExpressionTokenizer.getInstance(), Tokenizer), new Repetition([
				cast(NegationOperatorTokenizer.getInstance(), Tokenizer)
			]),	FilterOperandTokenizer.getInstance(), EndExpressionTokenizer.getInstance()
		]);
	}
	
	public function tokenize(state:TokenizeState):TokenizeState {
		return tokenizer.tokenize(state);
	}
	
}