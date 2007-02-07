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


package xpath.parser;
import xpath.parser.Parser;
import xpath.XPathInternalException;
import xpath.parser.ParseState;
import xpath.parser.ExpressionParser;
import xpath.token.BeginXPathToken;
import xpath.token.EndXPathToken;


class XPathParser implements Parser {
	
	private static var instance:XPathParser;
	
	
	public static function getInstance():XPathParser {
		if (instance == null) {
			instance = new XPathParser();
		}
		return instance;
	}
	
	private function new () {
	}
	
	public function parse (state:ParseState) :ParseState {
		if (!Std.is(state.tokens[state.pos], BeginXPathToken)) {
			// fail
			return state.newWorkingCopy();
		}

		var workingState:ParseState = state.newWorkingCopy();
		++workingState.pos;
		workingState = ExpressionParser.getInstance().parse(workingState);
		if (workingState.result == null) {
			throw new XPathInternalException("Invalid token stream");
		}
		
		if (!Std.is(state.tokens[workingState.pos], EndXPathToken)) {
			throw new XPathInternalException("Invalid token stream");
		}
		
		++workingState.pos;
		return workingState;
	}
	
}
