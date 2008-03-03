/* haXe XPath
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
import xpath.tokenizer.token.FixedStringTokenizer;
import xpath.tokenizer.Token;


/** [Tokenizer] which tokenizes according to the [ArgumentDelimiter]
 * rule. */
class ArgumentDelimiterTokenizer extends FixedStringTokenizer {
	
	static var instance :ArgumentDelimiterTokenizer;
	
	
	/** Gets the instance of [ArgumentDelimiterTokenizer]. */
	public static function getInstance () {
		if (instance == null) instance = new ArgumentDelimiterTokenizer();
		return instance;
	}
	
	function new () {
		super(new ArgumentDelimiterToken(), ",", "ArgumentDelimiter");
	}
	
}